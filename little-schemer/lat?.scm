(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

(define (lat? l)
   (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))
