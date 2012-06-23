/// @todo Finish this later.
library StructGuisDocument

	struct Document
		//constants
		private static constant integer maxLines = 10
		//
		private string title
		private string array line[Document.maxLines]
		private sound usedSound /// If you can hear a voice which is reading the document
	endstruct

endlibrary