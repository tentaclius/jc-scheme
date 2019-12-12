(load "lib.scm")

(define-class <SinOsc> ()
  (freq  init-value: 0 init-keyword: freq: getter: freq setter: set-freq)
  (phase init-value: 0 init-keyword: phase: getter: phase setter: set-phase) )

(define-method (calc (osc <SinOsc>))
  (set-phase osc (+ (phase osc) (* 2 pi (freq osc) (to-seconds 1))))
  (sin (phase osc)) ) 

(define carrier (make <SinOsc> freq: 440))
(define modulator (make <SinOsc> freq: 20))

(define (f t)
  (set-freq modulator (* 60 (mouse-x)))
  (set-freq carrier (+ 440 (* 100 (mouse-y) (calc modulator))))

  (* 0.3 (calc carrier)) )
