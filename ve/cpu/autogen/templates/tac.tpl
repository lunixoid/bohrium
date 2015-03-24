#compiler-settings
directiveStartToken= %
#end compiler-settings
%slurp
#ifndef __BH_VE_CPU_TAC
#define __BH_VE_CPU_TAC
//
//  NOTE: This file is autogenerated based on the tac-definition.
//        You should therefore not edit it manually.
//
#include "stdint.h"

// Bohrium custom types, used of representing
// two inputs in one constant... hopefully we can get
// rid of it... at some point...
typedef struct { uint64_t first, second; } pair_LL; 

#ifndef __BH_BASE
#define __BH_BASE
typedef struct
{
    /// The type of data in the array
    uint64_t       type;

    /// The number of elements in the array
    uint64_t      nelem;

    /// Pointer to the actual data.
    void*   data;
}bh_base;
#endif

typedef enum OPERATION {
    %for $op in $ops
    $addw($op['name']) = ${op['id']}$addsep($op, $ops)
    %end for
} OPERATION;

typedef enum OPERATOR {
    %for $oper in $opers
    $addw($oper['name'],15) = ${oper['id']}$addsep($oper, $opers)
    %end for
} OPERATOR;

typedef enum ETYPE {
    %for $type in $types
    $addw($type['name']) = ${type['id']}$addsep($type, $types)
    %end for
} ETYPE;

typedef enum LAYOUT {
    %for $layout in $layouts
    $addw($layout['name']) = ${layout['id']}$addsep($layout, $layouts)
    %end for
} LAYOUT;   // Uses a single byte

typedef struct tac {
    OPERATION op;       // Operation
    OPERATOR  oper;     // Operator
    uint32_t  out;      // Output operand
    uint32_t  in1;      // First input operand
    uint32_t  in2;      // Second input operand
    void* ext;
} tac_t;

typedef struct operand {
    LAYOUT  layout;     // The layout of the data
    void**  data;       // Pointer to pointer that points memory allocated for the array
    void*   const_data; // Pointer to constant
    ETYPE   etype;      // Type of the elements stored
    int64_t start;      // Offset from memory allocation to start of array
    int64_t nelem;      // Number of elements available in the allocation

    int64_t ndim;       // Number of dimensions of the array
    int64_t* shape;     // Shape of the array
    int64_t* stride;    // Stride in each dimension of the array
    bh_base* base;      // Pointer to operand base or NULL when layout == SCALAR_CONST.
} operand_t;            // Meta-data for a block argument

typedef struct iterspace {
    LAYOUT layout;  // The dominating layout
    int64_t ndim;   // The dominating rank/dimension of the iteration space
    int64_t* shape; // Shape of the iteration space
    int64_t nelem;  // The number of elements in the iteration space
} iterspace_t;

#define SCALAR_LAYOUT   ( SCALAR | SCALAR_CONST | SCALAR_TEMP )
#define ARRAY_LAYOUT    ( CONTRACTABLE | CONTIGUOUS | CONSECUTIVE | STRIDED | SPARSE )
#define COLLAPSIBLE     ( SCALAR | SCALAR_CONST | CONTRACTABLE | CONTIGUOUS | CONSECUTIVE )

#define EWISE           ( MAP | ZIP | GENERATE )
#define ARRAY_OPS       ( MAP | ZIP | GENERATE | REDUCE | SCAN )
#define NBUILTIN_OPS    %echo $len($ops)-1
#define NBUILTIN_OPERS  %echo $len($opers)-1
#define NON_FUSABLE     ( REDUCE | SCAN | EXTENSION )

#endif
