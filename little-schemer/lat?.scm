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

(display "member? 'poached '(fried eggs and scrambled eggs)) ")
(display (member? 'poached '(fried eggs and scrambled eggs)))
(display "\nmember? 'poached '(fried eggs and scrambled eggs poached))")
(display (member? 'poached '(fried eggs and scrambled eggs and poached)))
(display "\n")

(define (rember a lat)
  (cond
     ((null? lat) '())
     ((eq? a (car lat)) (rember a (cdr lat)))
     (else (cons (car lat) (rember a (cdr lat) ) ) )))


(display "rember 'mint '(lamb chops and mint jelly)) ")

(display (rember 'mint '(lamb chops and mint jelly)) )
