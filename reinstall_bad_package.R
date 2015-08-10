exception <- c("dynamicGraph", "TDA", "tgp", "pcalg")
loc <- '~/Library/R/3.1/library'

reinstall_bad_packages2 <- function(ps, exception) {
  for (p in ps) {
    print(p)
    if (!(p %in% exception)) {
      tryCatch(library(p,  character.only=TRUE), 
               error = function(e) {
                 install.packages(p)
               })
    }
  }
}

remove_duplicate_package <- function(orig_dir, dupl_dir) {
  orig_ps <- .packages(all.available = TRUE, lib.loc=orig_dir)
  dupl_ps <- .packages(all.available = TRUE, lib.loc=dupl_dir)
  for (p in orig_ps) {
    if (p %in% dupl_ps) {
      remove.packages(p, dupl_dir)
    }
  }
}

remove_duplicate_package('~/Library/R/3.2/library', loc)


reinstall_bad_packages2(.packages(all.available = TRUE, lib.loc=loc), 
                        exception)

reinstall_bad_packages <- function(loc, exception) {
  get_bad_packages <- function(ps, exception) {
    bps <- c()
    for (p in ps) {
      if (!(p %in% exception)) {
        tryCatch(library(p,  character.only=TRUE), 
                 error = function(e) {
                   bps <- append(bps, p)
                 }, finally = {
                   tryCatch(detach(paste("package:", p, sep=""), 
                                   character.only = TRUE), error = function(e) {})
                 })
      }
    }
    return(bps)
  }
  
  reinstall_packages <- function(ps) {
    for (p in ps) {
      install.packages(p)
    }
  }
  
  bad_packages <- get_bad_packages(
    .packages(all.available = TRUE, lib.loc=loc), exception)
  len <- length(bad_packages)
  while (len) {
    reinstall_packages(bad_packages)
    bad_packages <- get_bad_packages(
      .packages(all.available = TRUE, lib.loc=loc), exception)
    if (len == length(bad_packages)) {
      break;
    } else {
      len <- length(bad_packages)
    }
  }
}

reinstall_bad_packages(loc, exception)
remove_duplicate_package('~/Library/R/3.2/library', loc)
