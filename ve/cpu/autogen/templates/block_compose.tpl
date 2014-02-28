#compiler-settings
directiveStartToken= %
#end compiler-settings
%slurp
#include "block.hpp"
//
//  NOTE: This file is autogenerated based on the tac-definition.
//        You should therefore not edit it manually.
//
using namespace std;
namespace bohrium{
namespace engine{
namespace cpu{

/**
 *  Compose a block based on the instruction-nodes within a dag.
 */
bool Block::compose()
{
    DEBUG(">> Block::compose() : nnode("<< this->dag.nnode << ")");
    if (this->dag.nnode<1) {
        fprintf(stderr, "Got an empty dag. This cannot be right...\n");
        return false;
    }

    for (int i=0; i< this->dag.nnode; ++i) {
        if (dag.node_map[i] <0) {
            fprintf(stderr, "Code-generation for subgraphs is not supported yet.\n");
            return false;
        }

        this->instr[i] = &this->ir.instr_list[dag.node_map[i]];
        bh_instruction& instr = *this->instr[i];
        uint32_t out=0, in1=0, in2=0;

        //
        // Program packing: output argument
        // NOTE: All but BH_NONE has an output which is an array
        if (instr.opcode != BH_NONE) {
            out = this->add_operand(instr, 0);
        }

        //
        // Program packing; operator, operand and input argument(s).
        switch (instr.opcode) {    // [OPCODE_SWITCH]

            %for $opcode, $operation, $operator, $nin in $operations
            case $opcode:
                %if $opcode == 'BH_RANDOM'
                // This one requires special-handling... what a beaty...
                in1 = ++(this->noperands);                // Input
                this->scope[in1].layout    = CONSTANT;
                this->scope[in1].const_data= &(instr.constant.value.r123.start);
                this->scope[in1].data      = &(this->scope[in1].const_data);
                this->scope[in1].type      = UINT64;
                this->scope[in1].nelem     = 1;

                in2 = ++(this->noperands);
                this->scope[in2].layout    = CONSTANT;
                this->scope[in2].const_data= &(instr.constant.value.r123.key);
                this->scope[in2].data      = &(this->scope[in2].const_data);
                this->scope[in2].type      = UINT64;
                this->scope[in2].nelem     = 1;
                %else if 'ACCUMULATE' in $opcode or 'REDUCE' in $opcode
                in1 = this->add_operand(instr, 1);

                in2 = ++(this->noperands);
                this->scope[in2].layout    = CONSTANT;
                this->scope[in2].const_data= &(instr.constant.value.uint64);
                this->scope[in2].data      = &(this->scope[in2].const_data);
                this->scope[in2].type      = UINT64;
                this->scope[in2].nelem     = 1;
                %else
                %if nin >= 1
                in1 = this->add_operand(instr, 1);
                %end if
                %if nin >= 2
                in2 = this->add_operand(instr, 2);
                %end if
                %end if

                this->program[i].op    = $operation;  // TAC
                this->program[i].oper  = $operator;
                this->program[i].out   = out;
                this->program[i].in1   = in1;
                this->program[i].in2   = in2;
            
                this->omask |= $operation;    // Operationmask
                break;
            %end for

            default:
                if (instr.opcode>=BH_MAX_OPCODE_ID) {   // Handle extensions here

                    this->program[i].op   = EXTENSION; // TODO: Be clever about it
                    this->program[i].oper = EXTENSION_OPERATOR;
                    this->program[i].out  = 0;
                    this->program[i].in1  = 0;
                    this->program[i].in2  = 0;

                    cout << "Extension method." << endl;
                } else {
                    in1 = 1;
                    in2 = 2;
                    printf("compose: Err=[Unsupported instruction] {\n");
                    bh_pprint_instr(&instr);
                    printf("}\n");
                    DEBUG("<< Block::compose(ERROR)");
                    return BH_ERROR;
                }
        }
    }
    DEBUG("<< Block::compose(SUCCESS)");
    return BH_SUCCESS;
}

}}}
