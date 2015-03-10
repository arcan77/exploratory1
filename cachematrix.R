## Calcucating the inverse matrix caching already solved examples for faster computing next time.

makeCacheMatrix <- function(x = matrix()) { ## Returns a list of functions
    i <- NULL
    set <- function(y) { ## setting matrix 
        x <<- y
        i <<- NULL
    }
    get <- function() x { ## getting matrix 
    setinv <- function(solve) i <<- solve { ## setting inverse matrix 
    getinv <- function() i { ## getting inverse matrix
    list(set = set, get = get,
         setinv = setinv,
         getinv = getinv)
}


cacheSolve <- function(x, ...) { ## Calculating the inverse matrix 
    i <- x$getinv()
    
    if(!is.null(i)) { 
    ##Checking if the inverse for this matrix has been already calculated. 
    ##If so, returned calculated inverse matrix from cache
        message("getting cached data")
        return(i)
    }
    
    data <- x$get() ##Otherwise calculate inverse matrix... 
    i <- solve(data, ...) 
    x$setinv(i) ##..and set it in the cache
    i
    
}