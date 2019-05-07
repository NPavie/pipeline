import org.daisy.pipeline.braille.common.AbstractHyphenator;
import org.daisy.pipeline.braille.common.AbstractHyphenator.util.DefaultLineBreaker;
import org.daisy.pipeline.braille.common.AbstractTransformProvider;
import org.daisy.pipeline.braille.common.HyphenatorProvider;
import org.daisy.pipeline.braille.common.Query;
import static org.daisy.pipeline.braille.common.Query.util.query;

import org.osgi.service.component.annotations.Component;

public class MockHyphenator extends AbstractHyphenator {
	
	private static final LineBreaker lineBreaker = new DefaultLineBreaker() {
		protected Break breakWord(String word, int limit, boolean force) {
			if (limit >= 3 && word.equals("foobarz"))
				return new Break("fubbarz", 3, true);
			else if (limit >= word.length())
				return new Break(word, word.length(), false);
			else if (force)
				return new Break(word, limit, false);
			else
				return new Break(word, 0, false);
		}
	};
	
	@Override
	public LineBreaker asLineBreaker() {
		return lineBreaker;
	}
	
	private static final MockHyphenator instance = new MockHyphenator() {
		@Override
		public String getIdentifier() {
			return "mock";
		}
	};
	
	@Component(
		name = "mock-hyphenator-provider",
		service = { HyphenatorProvider.class }
	)
	public static class Provider extends AbstractTransformProvider<MockHyphenator>
	                             implements HyphenatorProvider<MockHyphenator> {
		{
			get(query("")); // in order to save instance in id-based cache
		}
		public Iterable<MockHyphenator> _get(Query query) {
			return AbstractTransformProvider.util.Iterables.<MockHyphenator>of(instance);
		}
	}
}
