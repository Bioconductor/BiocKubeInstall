#' @name local_sync
#'
#' @title Create a CRAN style local repository
#'
#' @param bucket `character(1)` The folder that will contain this repository.
#'   Can be set via `BIOCONDUCTOR_BINARY_REPOSITORY` environment variable or
#'   option.
#'
#' @inheritParams gcloud_create_cran_bucket
#'
#' @importFrom BiocBaseUtils isScalarCharacter
#'
#' @return `local_create_cran_bucket` returns a character vector of the path to
#'     the binary repository.
#' 
#' @examples
#' local_create_cran_bucket(
#'     folder = "bioconductor_docker",
#'     bioc_version = "3.21",
#'     bucket = "/host/"
#' )
#' @export
local_create_cran_bucket <- function(
    folder, bioc_version, secret = NULL, public = TRUE, bucket
) {
    stopifnot(isScalarCharacter(folder))
    
    if (missing(bucket)) {
        bucket <- Sys.getenv(
            "BIOCONDUCTOR_BINARY_REPOSITORY", Sys.getenv("R_PKG_CACHE_DIR")
        )
        bucket <- getOption("BIOCONDUCTOR_BINARY_REPOSITORY", bucket)
    }
    if (!length(bucket))
        stop(
            "Indicate a 'bucket' argument or set the",
            " 'BIOCONDUCTOR_BINARY_REPOSITORY' environment variable."
        )

    bin_base <- file.path(
        bucket, bioc_version, "container-binaries", folder
    )
    contrib_repo <- utils::contrib.url(bin_base)
    if (!dir.exists(contrib_repo)) 
        dir.create(contrib_repo, recursive = TRUE)

    return(contrib_repo)
}

.file_move <- function(source, dest, pattern) {
    files <- list.files(source, pattern = pattern, full.names = TRUE)
    destfiles <- file.path(dest, basename(files))
    if (length(files))
        file.rename(files, destfiles)
}

#' @export
local_sync_artifacts <-  function(artifacts, repos) {
    log_file <- file.path(artifacts$logs_path, 'kube_install.log')
    flog.appender(appender.tee(log_file), name = 'kube_install')
    
    ## Move .out files from bin_path to logs_path
    ## This avoids duplicate copy of PACKAGES* files to contrib(cran path)
    ## and to package_logs
    .output_file_move(artifacts)
    flog.info(
        'Moved .out files to %s: ', artifacts$logs_path, name = 'kube_install'
    )
    
    ## Sync binaries from /host/binary_3_13 to /src/contrib/
    .file_move(artifacts$bin_path, repos$binary, "\\.tar\\.gz$")
    flog.info(
        'Finished moving binaries to local storage: %s',
        artifacts$bin_path,
        name = 'kube_install'
    )
    
    ## Sync logs from /host/logs_3_13 to /src/package_logs
    .file_move(artifacts$logs_path, repos$logs, "\\.log$")
    flog.info(
        'Finished moving logs to local storage: %s',
        artifacts$logs_path,
        name = 'kube_install'
    )
    
    ## Obtain files from kubernetes instance to local
    flog.info(
        "Use 'kubectl cp worker:host/folder ./local/folder' to get files",
        name = 'kube_install'
    )
}
