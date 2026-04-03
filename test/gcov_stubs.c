// Stub definitions to satisfy gcov symbols during test linking
#include <stdint.h>
#include <stdlib.h>

void llvm_gcda_start_file(const char *filename, uint32_t version, uint32_t stamp) {}
void llvm_gcda_emit_function(uint32_t ident, const char *func_checksum, uint32_t cfg_checksum) {}
void llvm_gcda_emit_arcs(uint32_t num_counters, uint64_t *counters) {}
void llvm_gcda_summary_info(void) {}
void llvm_gcda_end_file(void) {}
void llvm_gcov_init(void *writeout, void *flush, void *reset) {}
