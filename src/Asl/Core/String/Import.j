//! import "Core/String/Struct Format.j"
//! import "Core/String/Struct Tokenizer.j"
//! import "Core/String/Library Conversion.j"
//! import "Core/String/Library Pool.j"
//! import "Core/String/Library Misc.j"

/**
 * \fn S2I
 * Converts string value \p s into integer value.
 * \param s String value which is converted into integer value.
 * \return Returns resulting integer value.
 *
 * \fn S2R
 * Converts string value \p s into real value.
 * \param s String value which is converted into real value.
 * \return Returns resulting real value.
 *
 * \fn StringLength
 * Returns length of string value \p s as integer value. For example "bla" has length of 3.
 * \param s String value whichs length is returned.
 * \return Returns length of string value \p s.
 *
 * \fn StringCase
 * Converts string value \p source into completely upper or lower string and returns the result.
 * \param source String value which is converted into specified case.
 * \param upper If this value is true it's converted into completely upper string value. Otherwise it's converted into completely lower string value.
 * \return Returns resulting string value.
 *
 * \fn StringHash
 * Generates an almost unique integer hash value by the corresponding string value \p s.
 * Hash values are mostly used as indices (e. g. in arrays or hashtables).
 * This function has been introduced to grant backwards compatibility to return bug based maps.
 * \param s String value from which hash value is generated.
 * \return Returns resulting hash value.
 * TODO add documentation!
 *
 * \fn GetLocalizedString
 * \warning Crashes the game in map selection when used in global constant:
 * \code
 * globals
 * 	constant string test = GetLocalizedString("bla") // causes crash!
 * endglobals
 * \endcode
 *
 * \fn GetLocalizedHotkey
 *
native GetLocalizedString takes string source returns string
native GetLocalizedHotkey takes string source returns integer
*/

/**
 * \fn I2S
 * Converts integer value \p i into string value.
 * \param r Integer value which is converted into string value.
 * \return Returns resulting string value.
 *
 * \fn R2S
 * Converts real value \p r into string value.
 * \param r Real value which is converted into string value.
 * \return Returns resulting string value.
 *
 * \fn R2SW
 * Converts real value \p r into string value using maximum value width \p width and precision \p precision.
 * \param r Real value which is converted into string value.
 * \param width Exact width of the resulting string. If the real number is not that long there will be inserted white-spaces at the beginning of the string value.
 * \param precision Exact precision. If it's higher than actual numbers after the dot there will be inserted 0 values at the end of the string value.
 * \return Returns resulting string value.
 * Examples:  R2SW(1.234, 7, 2) = "   1.23".  R2SW(1.234, 2, 5) = "1.23400".
 *
 * \fn SubString
 * \param source Source string from which the sub string is taken.
 * \param start start char position, starts with 0: 0 = first char, \ref StringLength - 1 = last char
 * \param end last char position, starts with 1: 1 = first char, \ref StringLength = last char
 * \sa StringLength
 */
library ACoreString requires AStructCoreStringFormat, AStructCoreStringTokenizer, ALibraryCoreStringConversion, ALibraryCoreStringPool, ALibraryCoreStringMisc
endlibrary