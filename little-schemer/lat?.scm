(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

(define lat?
   (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))

(define (remember? a lat)
  (cond
     ((null? lat) #f)
     ((eq? a (car lat)) #t)
     (else (remember? a (cdr lat)))))

(remember? 'poached '(fried eggs and scrambled eggs))
(remember? 'poached '(fried eggs and scrambled eggs and poached))
