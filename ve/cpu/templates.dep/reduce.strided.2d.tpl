//
// Reduction on two-dimensional arrays using strided indexing
{
    {{#OPERAND}}
    {{#SCALAR}}{{TYPE}} a{{NR}}_current = *a{{NR}}_first;{{/SCALAR}}
    {{#SCALAR_CONST}}const {{TYPE}} a{{NR}}_current = *a{{NR}}_first;{{/SCALAR_CONST}}
    {{#SCALAR_TEMP}}{{TYPE}} a{{NR}}_current;{{/SCALAR_TEMP}}
    {{#ARRAY}}{{TYPE}}* a{{NR}}_current = a{{NR}}_first;{{/ARRAY}}
    {{/OPERAND}}

    {{TYPE_AXIS}} axis = *a{{NR_SINPUT}}_first;
    {{TYPE_AXIS}} other_axis = (axis==0) ? 1 : 0;

    const int64_t nelements   = iterspace->shape[other_axis];
    const int mthreads        = omp_get_max_threads();
    const int64_t nworkers    = nelements > mthreads ? mthreads : 1;

    #pragma omp parallel for num_threads(nworkers)
    for(int64_t j=0; j<iterspace->shape[other_axis]; ++j) {
        
        {{TYPE_INPUT}}* tmp_current = a{{NR_FINPUT}}_first + \
                                      a{{NR_FINPUT}}_stride[other_axis] * j;

        {{TYPE_INPUT}} state = *tmp_current;                   // Scalar-temp 
        for(int64_t i=1; i<iterspace->shape[axis]; ++i) { // Accumulate
            tmp_current += a{{NR_FINPUT}}_stride[axis];

            {{#OPERATORS}}
            {{OPERATOR}};
            {{/OPERATORS}}
        }
        // Update array
        *(a{{NR_OUTPUT}}_first + a{{NR_OUTPUT}}_stride[0]*j) = state; 
    }

    // TODO: Handle write-out of non-temp and non-const scalars.
}
