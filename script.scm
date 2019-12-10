(use-modules (ice-9 match))

(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

(define (Sin f)
  (let ((phase 0)
        (t1 0)
        (freq f))
    (lambda args
      (match args
             (('freq) freq)
             (('set-freq f) (set! freq f) freq)
             (('phase) phase)
             (('set-phase p) (set! phase p) phase)

             ((t)
              (set! phase (+ phase (* 2 pi freq (seconds (- t t1)))))
              (set! t1 t)
              (sin phase) ) ))))

(define (Sin f)
  (let ((phase 0)
        (t1 0)
        (freq f))
    (lambda args
      (cond
        ((number? (car args))
         (let ((t (car args)))
           (set! phase (+ phase (* 2 pi freq (seconds (- t t1)))))
           (set! t1 t)
           (sin phase) ))
        ((equal? (car args) 'set-freq) (set! freq (cadr args))) ))))

;(define carrier (Sin 440))
;(define modulator (Sin 20))

(define (make-sin f) (vector f 0 0))
(define (sin-set-freq s f) (vector-set! s 0 f) )
(define (sin-freq s) (vector-ref s 0) )
(define (sin-set-phase s p) (vector-set! s 1 p) )
(define (sin-phase s) (vector-ref s 1) )
(define (sin-set-t1 s t) (vector-set! s 2 t))
(define (sin-t1 s) (vector-ref s 2))
(define (sin-calc s t)
  (sin-set-phase s (+ (sin-phase s) (* 2 pi (sin-freq s) (seconds (- t (sin-t1 s))))))
  (sin-set-t1 s t)
  (sin (sin-phase s)) )

(define carrier (make-sin 440))
(define modulator (make-sin 20))

(define (f t)
  (sin-set-freq modulator (* 60 (mouse-x)))
  (sin-set-freq carrier (+ 440 (* 100 (mouse-y) (sin-calc modulator t))))

  (* 0.3 (sin-calc carrier t)) )
