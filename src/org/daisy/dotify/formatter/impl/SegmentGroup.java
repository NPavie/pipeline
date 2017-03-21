package org.daisy.dotify.formatter.impl;

import java.util.ArrayList;
import java.util.List;

import org.daisy.dotify.formatter.impl.segment.TextSegment;

class SegmentGroup {		
	protected final List<Object> segments = new ArrayList<Object>();
	
	/*
	 * @returns the index of segment inside the group
	 */
	int add(TextSegment segment) {
		segments.add(segment);
		return segments.size()-1;
	}
	
	/*
	 * @returns the index of the child group inside the parent group
	 */
	int add(SegmentGroup group) {
		segments.add(group);
		return segments.size()-1;
	}
	
	TextSegment getSegmentAt(int idx) {
		return (TextSegment)segments.get(idx);
	}
	
	SegmentGroup getGroupAt(int idx) {
		return (SegmentGroup)segments.get(idx);
	}
}
