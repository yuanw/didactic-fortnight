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

(define (member? a lat)
  (cond
     ((null? lat) #f)
     ((eq? a (car lat)) #t)
     (else (member? a (cdr lat)))))

(display "member? 'poached '(fried eggs and scrambled eggs))")
(display (member? 'poached '(fried eggs and scrambled eggs)))
(display "member? 'poached '(fried eggs and scrambled eggs poached))")
(member? 'poached '(fried eggs and scrambled eggs and poached))
