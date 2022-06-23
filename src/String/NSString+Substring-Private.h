struct _MulleStringContext
{
   Class       stringClass;
   id          sharingObject;
   NSUInteger  sepLen;
};


MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF32StringWithStringContext( mulle_utf32_t *start,
                                                   mulle_utf32_t *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewASCIIStringWithStringContext( char *start,
                                                   char *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF16StringWithStringContext( mulle_utf16_t *start,
                                                   mulle_utf16_t *end,
                                                   struct _MulleStringContext *ctxt);
MULLE_OBJC_VALUE_FOUNDATION_GLOBAL
NSString   *_mulleNewUTF8StringWithStringContext( char *start,
                                                  char *end,
                                                  struct _MulleStringContext *ctxt);


static inline NSString   *_mulleNewSubstringFromASCIIData( NSString *self,
                                                           struct mulle_asciidata buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewASCIIStringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}


static inline NSString   *_mulleNewSubstringFromUTF16Data( NSString *self,
                                                           struct mulle_utf16data buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewUTF16StringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}


static inline NSString   *_mulleNewSubstringFromUTF32Data( NSString *self,
                                                           struct mulle_utf32data buf)
{
   struct _MulleStringContext   ctxt;

// need to init this for valgrind  ?
//   ctxt.stringClass   = Nil;
   ctxt.sharingObject = self;
   ctxt.sepLen        = 0;

   return( _mulleNewUTF32StringWithStringContext( buf.characters,
                                                  &buf.characters[ buf.length],
                                                  &ctxt));
}


