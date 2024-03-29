library(RedisParam)

Sys.setenv(REDIS_HOST = Sys.getenv("REDIS_SERVICE_HOST"))
Sys.setenv(REDIS_PORT = Sys.getenv("REDIS_SERVICE_PORT"))

p <- RedisParam(workers = 5, jobname = "binarybuild", is.worker = FALSE)

fun <- function(i) {
    Sys.sleep(1)
    Sys.info()[["nodename"]]
}

## 13 seconds / 5 workers = 3 seconds
system.time({
    res <- bplapply(1:13, fun, BPPARAM = p)
})

## each worker slept 2 or 3 times
table(unlist(res))
