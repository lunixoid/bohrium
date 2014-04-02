#ifndef __BH_VE_CPU_SYMBOLTABLE
#define __BH_VE_CPU_SYMBOLTABLE
#include "bh.h"
#include "tac.h"
#include <string>

namespace bohrium {
namespace engine {
namespace cpu {

/**
 *  Maintains a symbol table for tac_t operands (operand_t).
 *
 *  The symbol table relies on and uses bh_instructions, this is
 *  to ensure compability with the rest of Bohrium.
 *  The symbols and the operand_t provides identification of operands
 *  as well as auxilary information.
 *
 *  Populating the symbol table is therefore done by "mapping"
 *  a bh_instruction operand TO a symbol represented as an operand_t.
 *
 *  In the future this could be changed to actually be self-contained
 *  by replacing bh_instruction with tac_t. And instead of "mapping"
 *  one could "add" operands to the table.
 *
 */
class SymbolTable {
public:

    /**
     *  Construct a symbol table with a capacity for 100 symbols.
     */
    SymbolTable(void);
    
    /**
     *  Construct a symbol table with the given capacity of symbols.
     *
     *  @param capacity Upper bound on the amount of symbols in the table.
     */
    SymbolTable(size_t capacity);

    /**
     *  Deconstructor.
     */
    ~SymbolTable(void);

    /**
     * Create a textual representation of the table.
     */
    std::string text(void);
    
    /**
     * Create a textual representation of the table, using a prefix.
     */
    std::string text(std::string prefix);

    /**
     *  Add instruction operand as argument to block.
     *
     *  Reuses operands of equivalent meta-data.
     *
     *  @param instr        The instruction whos operand should be converted.
     *  @param operand_idx  Index of the operand to represent as arg_t
     *  @param block        The block in which scope the argument will exist.
     */
    size_t map_operand(bh_instruction& instr, size_t operand_idx);

private:
    /**
     *  Initialization function used by constructors.
     *
     *  @param capacity Upper bound on the amount of symbols in the table.
     */
    void init(size_t capacity);

    size_t nsymbols;    // The current number of symbols in the table
    operand_t* table;   // The actual symbol-table

};

}}}

#endif
