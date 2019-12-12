;(define carrier (make <SinOsc> freq: 440))
;(define modulator (make <SinOsc> freq: 20))
;
;(define (f t)
;  (set-freq modulator (* 60 (mouse-x)))
;  (set-freq carrier (+ 440 (* 100 (mouse-y) (calc modulator))))
;
;  (* 0.3 (calc carrier)) )

(define saw-osc (make <SawOsc> freq: 440 gain: 0.7))
(define adsr (make <ADSR> A: 0.1 D: 0.2 S: 0.6 R: 0.7))

(define (f t)
  (if (= 0 (modulo t (from-seconds 4)))
      (note-on adsr))
  (* (value adsr) (value saw-osc)) )
