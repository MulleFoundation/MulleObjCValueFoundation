/*
*   This file will be regenerated by `mulle-sde reflect` and any edits will be
*   lost. Suppress generation of this file with:
*      mulle-sde environment --global \
*         set MULLE_SOURCETREE_TO_C_INCLUDE_FILE DISABLE
*
*   To not generate any header files:
*      mulle-sde environment --global \
*         set MULLE_SOURCETREE_TO_C_RUN DISABLE
*/

#ifndef _MulleObjCValueFoundation_include_h__
#define _MulleObjCValueFoundation_include_h__

// How to tweak the following mulle-buffer #include
//    remove:             `mulle-sourcetree mark mulle-buffer no-header`
//    rename:             `mulle-sde dependency|library set mulle-buffer include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-buffer [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-buffer [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-buffer [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-buffer [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-buffer no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-buffer.h")
#   include "mulle-buffer.h"   // mulle-buffer
# else
#   include <mulle-buffer/mulle-buffer.h>   // mulle-buffer
# endif

// How to tweak the following mulle-utf #include
//    remove:             `mulle-sourcetree mark mulle-utf no-header`
//    rename:             `mulle-sde dependency|library set mulle-utf include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-utf [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-utf [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-utf [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-utf [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-utf no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-utf.h")
#   include "mulle-utf.h"   // mulle-utf
# else
#   include <mulle-utf/mulle-utf.h>   // mulle-utf
# endif

// How to tweak the following mulle-sprintf #include
//    remove:             `mulle-sourcetree mark mulle-sprintf no-header`
//    rename:             `mulle-sde dependency|library set mulle-sprintf include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-sprintf [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-sprintf [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-sprintf [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-sprintf [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-sprintf no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-sprintf.h")
#   include "mulle-sprintf.h"   // mulle-sprintf
# else
#   include <mulle-sprintf/mulle-sprintf.h>   // mulle-sprintf
# endif

#endif
