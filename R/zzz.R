
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  if (requireNamespace("reticulate", quietly = TRUE)) {
    py_dir <- system.file("python", package = pkgname)
    reticulate::py_run_string(sprintf(
      "import sys, os; p=r'%s';
if p not in sys.path: sys.path.insert(0, p)", py_dir))
  }
}
