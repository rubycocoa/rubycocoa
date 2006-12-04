/* ANSI-C code produced by gperf version 3.0.1 */
/* Command-line: gperf --switch=1 --language=ANSI-C --struct-type -N bs_xml_element BridgeSupport.gperf  */
/* Computed positions: -k'1' */

#if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
      && ('%' == 37) && ('&' == 38) && ('\'' == 39) && ('(' == 40) \
      && (')' == 41) && ('*' == 42) && ('+' == 43) && (',' == 44) \
      && ('-' == 45) && ('.' == 46) && ('/' == 47) && ('0' == 48) \
      && ('1' == 49) && ('2' == 50) && ('3' == 51) && ('4' == 52) \
      && ('5' == 53) && ('6' == 54) && ('7' == 55) && ('8' == 56) \
      && ('9' == 57) && (':' == 58) && (';' == 59) && ('<' == 60) \
      && ('=' == 61) && ('>' == 62) && ('?' == 63) && ('A' == 65) \
      && ('B' == 66) && ('C' == 67) && ('D' == 68) && ('E' == 69) \
      && ('F' == 70) && ('G' == 71) && ('H' == 72) && ('I' == 73) \
      && ('J' == 74) && ('K' == 75) && ('L' == 76) && ('M' == 77) \
      && ('N' == 78) && ('O' == 79) && ('P' == 80) && ('Q' == 81) \
      && ('R' == 82) && ('S' == 83) && ('T' == 84) && ('U' == 85) \
      && ('V' == 86) && ('W' == 87) && ('X' == 88) && ('Y' == 89) \
      && ('Z' == 90) && ('[' == 91) && ('\\' == 92) && (']' == 93) \
      && ('^' == 94) && ('_' == 95) && ('a' == 97) && ('b' == 98) \
      && ('c' == 99) && ('d' == 100) && ('e' == 101) && ('f' == 102) \
      && ('g' == 103) && ('h' == 104) && ('i' == 105) && ('j' == 106) \
      && ('k' == 107) && ('l' == 108) && ('m' == 109) && ('n' == 110) \
      && ('o' == 111) && ('p' == 112) && ('q' == 113) && ('r' == 114) \
      && ('s' == 115) && ('t' == 116) && ('u' == 117) && ('v' == 118) \
      && ('w' == 119) && ('x' == 120) && ('y' == 121) && ('z' == 122) \
      && ('{' == 123) && ('|' == 124) && ('}' == 125) && ('~' == 126))
/* The character set is not based on ISO-646.  */
#error "gperf generated tables don't work with this execution character set. Please report a bug to <bug-gnu-gperf@gnu.org>."
#endif

#line 1 "BridgeSupport.gperf"
struct bs_xml_atom { char *name; int val; };

#define TOTAL_KEYWORDS 11
#define MIN_WORD_LENGTH 4
#define MAX_WORD_LENGTH 17
#define MIN_HASH_VALUE 4
#define MAX_HASH_VALUE 22
/* maximum key range = 19, duplicates = 0 */

#ifdef __GNUC__
__inline
#else
#ifdef __cplusplus
inline
#endif
#endif
static unsigned int
hash (register const char *str, register unsigned int len)
{
  static unsigned char asso_values[] =
    {
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23,  0,
      23,  0,  5, 23, 23,  5, 23, 23, 23,  5,
      23, 23, 23, 23, 23, 10, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23, 23, 23, 23, 23,
      23, 23, 23, 23, 23, 23
    };
  return len + asso_values[(unsigned char)str[0]];
}

#ifdef __GNUC__
__inline
#endif
struct bs_xml_atom *
bs_xml_element (register const char *str, register unsigned int len)
{
  static struct bs_xml_atom wordlist[] =
    {
#line 4 "BridgeSupport.gperf"
      {"enum", 2 },
#line 9 "BridgeSupport.gperf"
      {"class", 7},
#line 13 "BridgeSupport.gperf"
      {"cftype", 11},
#line 3 "BridgeSupport.gperf"
      {"constant", 1},
#line 12 "BridgeSupport.gperf"
      {"method", 10},
#line 7 "BridgeSupport.gperf"
      {"function", 5},
#line 10 "BridgeSupport.gperf"
      {"method_arg", 8},
#line 5 "BridgeSupport.gperf"
      {"struct", 3 },
#line 8 "BridgeSupport.gperf"
      {"function_arg", 6},
#line 11 "BridgeSupport.gperf"
      {"method_retval", 9},
#line 6 "BridgeSupport.gperf"
      {"informal_protocol", 4}
    };

  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register int key = hash (str, len);

      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)
        {
          register struct bs_xml_atom *resword;

          switch (key - 4)
            {
              case 0:
                resword = &wordlist[0];
                goto compare;
              case 1:
                resword = &wordlist[1];
                goto compare;
              case 2:
                resword = &wordlist[2];
                goto compare;
              case 4:
                resword = &wordlist[3];
                goto compare;
              case 7:
                resword = &wordlist[4];
                goto compare;
              case 9:
                resword = &wordlist[5];
                goto compare;
              case 11:
                resword = &wordlist[6];
                goto compare;
              case 12:
                resword = &wordlist[7];
                goto compare;
              case 13:
                resword = &wordlist[8];
                goto compare;
              case 14:
                resword = &wordlist[9];
                goto compare;
              case 18:
                resword = &wordlist[10];
                goto compare;
            }
          return 0;
        compare:
          {
            register const char *s = resword->name;

            if (*str == *s && !strcmp (str + 1, s + 1))
              return resword;
          }
        }
    }
  return 0;
}
#line 14 "BridgeSupport.gperf"

#define BS_XML_CONSTANT           1
#define BS_XML_ENUM               2
#define BS_XML_STRUCT             3
#define BS_XML_INFORMAL_PROTOCOL  4
#define BS_XML_FUNCTION           5
#define BS_XML_FUNCTION_ARG       6
#define BS_XML_CLASS              7
#define BS_XML_METHOD_ARG         8
#define BS_XML_METHOD_RETVAL      9
#define BS_XML_METHOD             10
#define BS_XML_CFTYPE             11
