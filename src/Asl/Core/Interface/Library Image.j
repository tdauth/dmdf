/**
 * \defgroup images Images
 * Required image file properties (listed by PitzerMike):
 * <ul>
 * <li>Image files must have an invisible border of 1 pixel</li>
 * <li>You have to create new image files with their original size and a transparent background</li>
 * <li>Image file sizes have to be a power of 2</li>
 * <li>You have to insert your bordered image file into the transparent one</li>
 * <li>Image files may only have RGB channels (no alpha channels)</li>
 * <li>Image files have to be saved as 32 Bit TGA</li>
 * <li>Image files should be converted into BLP format</li>
 * </ul>
 */
library ALibraryCoreInterfaceImage requires optional ALibraryCoreDebugMisc

	/**
	 * Creates an image using default parameters which should work well.
	 * Besides you can define size dimensions.
	 * \ingroup images
	 */
	function CreateImageEx takes string file, real x, real y, real z, real sizeX, real sizeY returns image
		local image result = CreateImage(file, sizeX, sizeY, 0.0, (x - (sizeX / 2.0)), (y - (sizeY / 2.0)), z, 0.0, 0.0, 0.0, 2) // image is placed in centre
		call SetImageRenderAlways(result, true)

		return result
	endfunction

	/**
	 * Shows or hides image \p whichImage for player \p whichPlayer.
	 * \param whichPlayer Player who the image is shown or hidden to.
	 * \param whichImage Image handle which should be shown or hidden.
	 * \param show If this value is true image \p whichImage will be shown otherwise it will be hidden.
	 * \ingroup images
	 */
	function ShowImageForPlayer takes player whichPlayer, image whichImage, boolean show returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call ShowImage(whichImage, show)
		endif
	endfunction

	/**
	 * Combines \ref CreateImageEx() and \ref ShowImageForPlayer().
	 * \param show If true, image is shown to player \p whichPlayer after creation. Otherwise it stays hidden.
	 * \ingroup images
	 */
	function CreateImageForPlayer takes player whichPlayer, string file, real x, real y, real z, real sizeX, real sizeY, boolean show returns image
		local image result = CreateImageEx(file, x, y, z, sizeX, sizeY)
		call ShowImage(result, false)
		if (show) then
			call ShowImageForPlayer(whichPlayer, result, true)
		endif
		return result
	endfunction

endlibrary