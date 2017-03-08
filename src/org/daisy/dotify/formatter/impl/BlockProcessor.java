package org.daisy.dotify.formatter.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.daisy.dotify.api.formatter.FormattingTypes.BreakBefore;
import org.daisy.dotify.api.formatter.FormattingTypes.Keep;

/**
 * Provides data about a single rendering scenario.
 * 
 * @author Joel Håkansson
 */
abstract class BlockProcessor {
	private int keepWithNext = 0;
	
	abstract void newRowGroupSequence(VerticalSpacing vs);
	
	abstract boolean hasSequence();
	abstract boolean hasResult();
	abstract void addRowGroup(RowGroup rg);
	abstract RowGroup peekResult();
	
	BlockProcessor() {
		this.keepWithNext = 0;
	}

	BlockProcessor(BlockProcessor template) {
		this.keepWithNext = template.keepWithNext;
	}

	private int getKeepWithNext() {
		return keepWithNext;
	}

	private void setKeepWithNext(int keepWithNext) {
		this.keepWithNext = keepWithNext;
	}
		
	void processBlock(LayoutMaster master, Block g, AbstractBlockContentManager bcm) {
		if (!hasSequence() || ((g.getBreakBeforeType()==BreakBefore.PAGE  || g.getVerticalPosition()!=null) && hasResult())) {
            newRowGroupSequence(
                    g.getVerticalPosition()!=null?
                            new VerticalSpacing(g.getVerticalPosition(), new RowImpl("", bcm.getLeftMarginParent(), bcm.getRightMarginParent()))
                                    :null
            );
			setKeepWithNext(-1);
		}
		List<RowGroup> store = new ArrayList<>();

		InnerBlockProcessor ibp = new InnerBlockProcessor(master, g, bcm);
		while (ibp.hasNext()) {
			store.add(ibp.next());
		}

		if (store.isEmpty() && hasSequence()) {
			RowGroup gx = peekResult();
			if (gx!=null && gx.getAvoidVolumeBreakAfterPriority()==g.getAvoidVolumeBreakInsidePriority()
					&&gx.getAvoidVolumeBreakAfterPriority()!=g.getAvoidVolumeBreakAfterPriority()) {
				gx.setAvoidVolumeBreakAfterPriority(g.getAvoidVolumeBreakAfterPriority());
			}
		} else {
			for (int j=0; j<store.size(); j++) {
				RowGroup b = store.get(j);
				if (j==store.size()-1) { //!hasNext()
					b.setAvoidVolumeBreakAfterPriority(g.getAvoidVolumeBreakAfterPriority());
				} else {
					b.setAvoidVolumeBreakAfterPriority(g.getAvoidVolumeBreakInsidePriority());
				}
				addRowGroup(b);
			}
		}
	}
	
	private class InnerBlockProcessor implements Iterator<RowGroup> {
		private final LayoutMaster master;
		private final Block g;
		private final AbstractBlockContentManager bcm;
		private final Iterator<RowImpl> ri;
		private final OrphanWidowControl owc;
		private int i;
		private int phase;

		private InnerBlockProcessor(LayoutMaster master, Block g, AbstractBlockContentManager bcm) {
			this.master = master;
			this.g = g;
			this.bcm = bcm;
			this.ri = bcm.iterator();
			this.phase = 0;
			this.i = 0;
			this.owc = new OrphanWidowControl(g.getRowDataProperties().getOrphans(),
					g.getRowDataProperties().getWidows(), 
					bcm.getRowCount());

		}
		
		@Override
		public boolean hasNext() {
			// these conditions must match the ones in next()
			return 
				phase < 1 && bcm.hasCollapsiblePreContentRows()
				||
				phase < 2 && bcm.hasInnerPreContentRows()
				||
				phase < 3 && shouldAddGroupForEmptyContent()
				||
				phase < 4 && ri.hasNext()
				||
				phase < 5 && bcm.hasPostContentRows()
				||
				phase < 6 && bcm.hasSkippablePostContentRows();
		}
		
		@Override
		public RowGroup next() {
			if (phase==0) {
				phase++;
				//if there is a row group, return it (otherwise, try next phase)
				if (bcm.hasCollapsiblePreContentRows()) {
					return new RowGroup.Builder(master.getRowSpacing(), bcm.getCollapsiblePreContentRows()).
											collapsible(true).skippable(false).breakable(false).build();
				}
			}
			if (phase==1) {
				phase++;
				//if there is a row group, return it (otherwise, try next phase)
				if (bcm.hasInnerPreContentRows()) {
					return new RowGroup.Builder(master.getRowSpacing(), bcm.getInnerPreContentRows()).
											collapsible(false).skippable(false).breakable(false).build();
				}
			}
			if (phase==2) {
				phase++;
				//TODO: Does this interfere with collapsing margins?
				if (shouldAddGroupForEmptyContent()) {
					RowGroup.Builder rgb = new RowGroup.Builder(master.getRowSpacing(), new ArrayList<RowImpl>());
					setProperties(rgb, bcm, g);
					return rgb.build();
				}
			}
			if (phase==3) {
				if (ri.hasNext()) {
					i++;
					RowImpl r = ri.next();
					r.setAdjustedForMargin(true);
					if (!ri.hasNext()) {
						//we're at the last line, this should be kept with the next block's first line
						setKeepWithNext(g.getKeepWithNext());
					}
					RowGroup.Builder rgb = new RowGroup.Builder(master.getRowSpacing()).add(r).
							collapsible(false).skippable(false).breakable(
									r.allowsBreakAfter()&&
									owc.allowsBreakAfter(i-1)&&
									getKeepWithNext()<=0 &&
									(Keep.AUTO==g.getKeepType() || i==bcm.getRowCount()) &&
									(i<bcm.getRowCount() || !bcm.hasPostContentRows())
									);
					if (i==1) { //First item
						setProperties(rgb, bcm, g);
					}
					setKeepWithNext(getKeepWithNext()-1);
					return rgb.build();
				} else {
					phase++;
				}
			}
			if (phase==4) {
				phase++;
				if (bcm.hasPostContentRows()) {
					return new RowGroup.Builder(master.getRowSpacing(), bcm.getPostContentRows()).
						collapsible(false).skippable(false).breakable(getKeepWithNext()<0).build();
				}
			}
			if (phase==5) {
				phase++;
				if (bcm.hasSkippablePostContentRows()) {
					return new RowGroup.Builder(master.getRowSpacing(), bcm.getSkippablePostContentRows()).
						collapsible(true).skippable(true).breakable(getKeepWithNext()<0).build();
				}
			}
			return null;
		}
		
		private boolean shouldAddGroupForEmptyContent() {
			return !ri.hasNext() && (!bcm.getGroupAnchors().isEmpty() || !bcm.getGroupMarkers().isEmpty() || !"".equals(g.getIdentifier())
					|| g.getKeepWithNextSheets()>0 || g.getKeepWithPreviousSheets()>0);
		}
	}
	
	private static void setProperties(RowGroup.Builder rgb, AbstractBlockContentManager bcm, Block g) {
		if (!"".equals(g.getIdentifier())) { 
			rgb.identifier(g.getIdentifier());
		}
		rgb.markers(bcm.getGroupMarkers());
		rgb.anchors(bcm.getGroupAnchors());
		rgb.keepWithNextSheets(g.getKeepWithNextSheets());
		rgb.keepWithPreviousSheets(g.getKeepWithPreviousSheets());
	}
}