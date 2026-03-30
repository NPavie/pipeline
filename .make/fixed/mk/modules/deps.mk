modules/VERSION := 1.15.4

.SECONDARY : modules/.install
modules/.install :

check : $(TARGET_DIR)/state/modules/last-tested
.PHONY : $(TARGET_DIR)/state/modules/last-tested
$(TARGET_DIR)/state/modules/last-tested : \
	$(TARGET_DIR)/state/modules/bom/last-tested \
	$(TARGET_DIR)/state/modules/parent/last-tested \
	$(TARGET_DIR)/state/modules/common/common-utils/last-tested \
	$(TARGET_DIR)/state/modules/common/file-utils/last-tested \
	$(TARGET_DIR)/state/modules/common/fileset-utils/last-tested \
	$(TARGET_DIR)/state/modules/common/mediatype-utils/last-tested \
	$(TARGET_DIR)/state/modules/common/validation-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/ace-adapter/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/asciimath-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/css-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/html-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/daisy202-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/daisy3-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/dtbook-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/epub-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/mathml-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/mathcat-adapter/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/smil-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/ocr-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/odf-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/pandoc-adapter/last-tested \
	$(TARGET_DIR)/state/modules/scripts-utils/zedai-utils/last-tested \
	$(TARGET_DIR)/state/modules/nlp/nlp-common/last-tested \
	$(TARGET_DIR)/state/modules/nlp/lexers/ruled-lexer/last-tested \
	$(TARGET_DIR)/state/modules/nlp/lexers/omnilang-lexer/last-tested \
	$(TARGET_DIR)/state/modules/audio/audio-common/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-common/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-espeak/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-acapela/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-osx/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-sapinative/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-qfrency/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-google/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-cereproc/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-azure/last-tested \
	$(TARGET_DIR)/state/modules/tts/tts-adapter-aws/last-tested \
	$(TARGET_DIR)/state/modules/braille/braille-common/last-tested \
	$(TARGET_DIR)/state/modules/braille/braille-css-utils/last-tested \
	$(TARGET_DIR)/state/modules/braille/pef-utils/last-tested \
	$(TARGET_DIR)/state/modules/braille/liblouis-utils/last-tested \
	$(TARGET_DIR)/state/modules/braille/dotify-utils/last-tested \
	$(TARGET_DIR)/state/modules/braille/libhyphen-utils/last-tested \
	$(TARGET_DIR)/state/modules/braille/texhyph-utils/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy202-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy202-validator/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy202-to-daisy3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy202-to-mp3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy3-to-daisy202/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy3-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/daisy3-to-mp3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-daisy3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-ebraille/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-html/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-odt/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-pef/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-rtf/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-zedai/last-tested \
	$(TARGET_DIR)/state/modules/scripts/dtbook-validator/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub-to-daisy/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub2-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy202/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub3-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/epub3-to-pef/last-tested \
	$(TARGET_DIR)/state/modules/scripts/html-to-dtbook/last-tested \
	$(TARGET_DIR)/state/modules/scripts/html-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/html-to-pef/last-tested \
	$(TARGET_DIR)/state/modules/scripts/nimas-fileset-validator/last-tested \
	$(TARGET_DIR)/state/modules/scripts/word-to-dtbook/last-tested \
	$(TARGET_DIR)/state/modules/scripts/zedai-to-epub3/last-tested \
	$(TARGET_DIR)/state/modules/scripts/zedai-to-html/last-tested \
	$(TARGET_DIR)/state/modules/scripts/zedai-to-pef/last-tested

.SECONDARY : modules/.release
