/*
 * Copyright 2011 Troels Blum <troels@blum.dk>
 *
 * This file is part of cphVB <http://code.google.com/p/cphvb/>.
 *
 * cphVB is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * cphVB is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with cphVB. If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include <cphvb.h>
#include "ArrayOperand.hpp"

ArrayOperand::ArrayOperand(cphvb_array* spec_) 
    : spec(spec_)
{}


size_t ArrayOperand::size()
{
    return cphvb_nelements(spec->ndim, spec->shape);
}

void ArrayOperand::printOn(std::ostream& os) const
{
    os << "cphVBarray ID: " << spec << " {" << std::endl; 
    os << "\towner: " << spec->owner << std::endl; 
    os << "\tbase: " << spec->base << std::endl; 
    os << "\ttype: " << cphvb_type_text(spec->type) << std::endl; 
    os << "\tndim: " << spec->ndim << std::endl; 
    os << "\tstart: " << spec->start << std::endl; 
    for (int i = 0; i < spec->ndim; ++i)
    {
        os << "\tshape["<<i<<"]: " << spec->shape[i] << std::endl;
    } 
    for (int i = 0; i < spec->ndim; ++i)
    {
        os << "\tstride["<<i<<"]: " << spec->stride[i] << std::endl;
    } 
    os << "\tdata: " << spec->data << std::endl; 
    os << "\thas_init_value: " << spec->has_init_value << std::endl;
    switch(spec->type)
    {
    case CPHVB_INT32:
        os << "\tinit_value: " << spec->init_value.int32 << std::endl;
        break;
    case CPHVB_UINT32:
        os << "\tinit_value: " << spec->init_value.uint32 << std::endl;
        break;
    case CPHVB_FLOAT32:
        os << "\tinit_value: " << spec->init_value.float32 << std::endl;
        break;
    }
    os << "\tref_count: " << spec->ref_count << std::endl; 
    os << "}"<< std::endl;
}

std::ostream& operator<< (std::ostream& os, 
                          ArrayOperand const& array)
{
    array.printOn(os);
    return os;
}

cphvb_array* ArrayOperand::getSpec()
{
    return spec;
}
