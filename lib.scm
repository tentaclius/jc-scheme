(use-modules (ice-9 hash-table))
(use-modules (srfi srfi-9))
(use-modules (srfi srfi-88))  ;; keywords
(use-modules (oop goops))     ;; oop

(define pi 3.141592653589793)
(define (to-seconds t) (/ t (sample-rate)))
(define (from-seconds t) (inexact->exact (round (* t (sample-rate)))))

(define (limit x a b)
  (max (min x b) a))

(define (in-range? x a b)
  (and (<= x b) (>= x a)))

;; create a simple iterative loop sequence
(define (make-loop-seq . args)
  (let ((sequence args)
        (i 0))
    (lambda ()
      (let ((s (sequence i)))
        (set! i (+ i 1))
        (if (>= i (length sequence)) (set! i 0))
        s))))

;; convert a note number or name to the frequency
(define note->freq
  (let 
    ((notes-vec (vector
                  8.1757989156 8.6619572180 9.1770239974 9.7227182413 10.3008611535 10.9133822323 11.5623257097 12.2498573744
                  12.9782717994 13.7500000000 14.5676175474 15.4338531643 16.3515978313 17.3239144361 18.3540479948 19.4454364826
                  20.6017223071 21.8267644646 23.1246514195 24.4997147489 25.9565435987 27.5000000000 29.1352350949 30.8677063285
                  32.7031956626 34.6478288721 36.7080959897 38.8908729653 41.2034446141 43.6535289291 46.2493028390 48.9994294977
                  51.9130871975 55.0000000000 58.2704701898 61.7354126570 65.4063913251 69.2956577442 73.4161919794 77.7817459305
                  82.4068892282 87.3070578583 92.4986056779 97.9988589954 103.8261743950 110.0000000000 116.5409403795 123.4708253140
                  130.8127826503 138.5913154884 146.8323839587 155.5634918610 164.8137784564 174.6141157165 184.9972113558 195.9977179909
                  207.6523487900 220.0000000000 233.0818807590 246.9416506281 261.6255653006 277.1826309769 293.6647679174 311.1269837221
                  329.6275569129 349.2282314330 369.9944227116 391.9954359817 415.3046975799 440.0000000000 466.1637615181 493.8833012561
                  523.2511306012 554.3652619537 587.3295358348 622.2539674442 659.2551138257 698.4564628660 739.9888454233 783.9908719635
                  830.6093951599 880.0000000000 932.3275230362 987.7666025122 1046.5022612024 1108.7305239075 1174.6590716696 1244.5079348883
                  1318.5102276515 1396.9129257320 1479.9776908465 1567.9817439270 1661.2187903198 1760.0000000000 1864.6550460724 1975.5332050245
                  2093.0045224048 2217.4610478150 2349.3181433393 2489.0158697766 2637.0204553030 2793.8258514640 2959.9553816931 3135.9634878540
                  3322.4375806396 3520.0000000000 3729.3100921447 3951.0664100490 4186.0090448096 4434.9220956300 4698.6362866785 4978.0317395533
                  5274.0409106059 5587.6517029281 5919.9107633862 6271.9269757080 6644.8751612791 7040.0000000000 7458.6201842894 7902.1328200980
                  8372.0180896192 8869.8441912599 9397.2725733570 9956.0634791066 10548.0818212118 11175.3034058561 11839.8215267723 12543.8539514160))
     (note-names (alist->hash-table '(
                   (C1  . 0)  (Db1 . 1)  (C#1 . 1)  (D1  . 2) (D#1 . 3)  (Eb1 . 3)  (E1  . 4)  (F1  . 5)
                   (F#1 . 6)  (Gb1 . 6)  (G1  . 7)  (G#1 . 8) (Ab1 . 8)  (A1  . 9)  (A#1 . 10) (Bb1 . 10)
                   (B1  . 11) (C2  . 12) (C#2 . 13) (Db2 . 13) (D2  . 14) (D#2 . 15) (Eb2 . 15) (E2  . 16)
                   (F2  . 17) (F#2 . 18) (Gb2 . 18) (G2  . 19) (G#2 . 20) (Ab2 . 20) (A2  . 21) (A#2 . 22)
                   (Bb2 . 22) (B2  . 23) (C3  . 24) (C#3 . 25) (Db3 . 25) (D3  . 26) (D#3 . 27) (Eb3 . 27)
                   (E3  . 28) (F3  . 29) (F#3 . 30) (Gb3 . 30) (G3  . 31) (G#3 . 32) (Ab3 . 32) (A3  . 33)
                   (A#3 . 34) (Bb3 . 34) (B3  . 35) (C4  . 36) (C#4 . 37) (Db4 . 37) (D4  . 38) (D#4 . 39)
                   (Eb4 . 39) (E4  . 40) (F4  . 41) (F#4 . 42) (Gb4 . 42) (G4  . 43) (G#4 . 44) (Ab4 . 44)
                   (A4  . 45) (A#4 . 46) (Bb4 . 46) (B4  . 47) (C5  . 48) (C#5 . 49) (Db5 . 49) (D5  . 50)
                   (D#5 . 51) (Eb5 . 51) (E5  . 52) (F5  . 53) (F#5 . 54) (Gb5 . 54) (G5  . 55) (G#5 . 56)
                   (Ab5 . 56) (A5  . 57) (A#5 . 58) (Bb5 . 58) (B5  . 59) (C6  . 60) (C#6 . 61) (Db6 . 61)
                   (D6  . 62) (D#6 . 63) (Eb6 . 63) (E6  . 64) (F6  . 65) (F#6 . 66) (Gb6 . 66) (G6  . 67)
                   (G#6 . 68) (Ab6 . 68) (A6  . 69) (A#6 . 70) (Bb6 . 70) (B6  . 71) (C7  . 72) (C#7 . 73)
                   (Db7 . 73) (D7  . 74) (D#7 . 75) (Eb7 . 75) (E7  . 76) (F7  . 77) (F#7 . 78) (Gb7 . 78)
                   (G7  . 79) (G#7 . 80) (Ab7 . 80) (A7  . 81) (A#7 . 82) (Bb7 . 82) (B7  . 83) (C8  . 84)
                   (C#8 . 85) (Db8 . 85) (D8  . 86) (D#8 . 87) (Eb8 . 87) (E8  . 88) (F8  . 89) (F#8 . 90)
                   (Gb8 . 90) (G8  . 91) (G#8 . 92) (Ab8 . 92) (A8  . 93) (A#8 . 94) (Bb8 . 94) (B8  . 95)
                   (C9  . 96) (C#9 . 97) (Db9 . 97) (D9  . 98) (D#9 . 99) (Eb9 . 99) (E9  . 100) (F9 . 101)
                   (F#9  . 102) (Gb9  . 102) (G9   . 103) (G#9  . 104) (Ab9  . 104) (A9   . 105) (A#9  . 106) (Bb9  . 106)
                   (B9   . 107) (C10  . 108) (C#10 . 109) (Db10 . 109) (D10  . 110) (D#10 . 111) (Eb10 . 111) (E10  . 112)
                   (F10  . 113) (F#10 . 114) (Gb10 . 114) (G10  . 115) (G#10 . 116) (Ab10 . 116) (A10  . 117) (A#10 . 118)
                   (Bb10 . 118) (B10  . 119) (C11  . 120) (C#11 . 121) (Db11 . 121) (D11  . 122) (D#11 . 123) (Eb11 . 123)
                   (E11  . 124) (F11  . 125) (F#11 . 126) (Gb11 . 126) (G11  . 127) ))) )

    (lambda (n)
      (cond
        ((number? n) (vector-ref notes-vec n))
        ((symbol? n) (vector-ref notes-vec (hash-ref note-names n)))
        (else 0))) ))

;; line up class
(define-class <Line> () 
  (from  init-value: 0  init-keyword: #:from)
  (to    init-value: 1  init-keyword: #:to)
  (dur   init-form: (from-seconds 1) init-keyword: #:dur)
  (t     init-value: 0) )

(define-method (value (l <Line>))
  (let ((from (slot-ref l 'from))
        (to   (slot-ref l 'to))
        (dur  (slot-ref l 'dur))
        (t    (slot-ref l 't)))
    (slot-set! l 't (+ t 1))
    (+ from (* (/ (limit t 0 dur) dur) (- to from))) ))

(define-method (reset (l <Line>))
  (slot-set! l 't 0) )

;; adsr
(define-class <ADSR> ()
  (A  init-value: 0  init-keyword: #:A)
  (D  init-value: 0  init-keyword: #:D)
  (S  init-value: 0  init-keyword: #:S)
  (R  init-value: 0  init-keyword: #:R)
  (t  init-value: 0)
  (phase init-value: 'off) )

(define-method (note-on (s <ADSR>))
  (slot-set! s 't 0)
  (slot-set! s 'phase 'on))

(define-method (note-off (s <ADSR>))
   (slot-set! s 't 0)
   (slot-set! s 'phase 'release) )

(define-method (value (s <ADSR>))
   (let ((A (slot-ref s 'A))
         (D (slot-ref s 'D))
         (S (slot-ref s 'S))
         (R (slot-ref s 'R))
         (t (to-seconds (slot-ref s 't))) )

     (define (value-adsr a d s)
       (cond
         ((in-range? t 0 a)
          (/ t a))
         ((in-range? t a (+ a d))
          (- 1 (* (/ (- t a) d) (- 1 s))) )
         ((> t d) s)
         (else 0) ))

     (slot-set! s 't (+ (slot-ref s 't) 1))
     (case (slot-ref s 'phase)
       ((on) (value-adsr A D S))
       ((off) 0)
       ((release)
        (if (>= t R) (slot-set! s 'phase 'off))
        (* (/ (- R (limit t 0 R)) R) S) )
       (else 0) )))

;; Base class for oscilators
(define-class <Osc> ()
   (gain  init-value: 1  init-keyword: #:gain  getter: gain  setter: set-gain) )

;; Sin oscilator
(define-class <SinOsc> (<Osc>)
  (freq  init-value: 0 init-keyword: freq: getter: freq setter: set-freq)
  (phase init-value: 0 init-keyword: phase: getter: phase setter: set-phase) )

(define-method (value (osc <SinOsc>))
  (set-phase osc (+ (phase osc) (* 2 pi (freq osc) (to-seconds 1))))
  (* (gain osc) (sin (phase osc))) ) 

;; Saw oscilator
(define-class <SawOsc> (<Osc>)
   (freq  init-value: 0  init-keyword: #:freq  getter: freq  setter: set-freq)
   (phase init-value: 0  init-keyword: #:phase getter: phase setter: set-phase) )

(define-method (value (osc <SawOsc>))
  (set-phase osc (+ (phase osc) (* (freq osc) (to-seconds 1))))
  (* (gain osc) (- (* 2 (- (phase osc) (floor (phase osc)))) 1)) )
