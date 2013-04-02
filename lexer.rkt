#lang racket
; Input and output streams for user-generated code and tokens
(define in (open-input-file "input.txt"))
(define out (open-output-file "tokens.txt" #:mode 'text))

; Remove last element from list and flatten if necessary
(define (remove-last lst)
  (reverse (cdr (reverse (flatten lst)))))

; Tokenize list of chars and store result in second argument
(define (tokenize chars result)
  (define c (read-char in))
  (unless (eof-object? c)
    (cons (clean-token (build-token chars c)) (tokenize chars result)))) 

; Creates a token of a string with no whitespace chars
(define (build-token lst c)
    (unless (char-whitespace? c)
    (cons c (build-token lst (read-char in)))))

; This converts a token in the original list of tokens into
; a single string.  Because of the way that the tokenize function
; works; simply calling (list->string token) doesn't work.
(define (clean-token lst)
   (list->string 
     (remove-last lst)))

; Simple set of boolean functions to test what type a token is
; given the calculator language
(define (is-read? t) (string=? t "read"))
(define (is-write? t) (string=? t "write"))
(define (is-add-op? t) (string=? t "+"))
(define (is-sub-op? t) (string=? t "-"))
(define (is-mult-op? t) (string=? t "*"))
(define (is-div-op? t) (string=? t "/"))
(define (is-assign-op? t) (string=? t ":="))
(define (is-lparen? t) (string=? t "("))
(define (is-rparen? t) (string=? t ")"))
(define (is-id? t)
  (if (or (is-read? t)  (is-write? t)) 
      #f
      (string=? t 
                (car (regexp-match #rx"[a-zA-Z]*" t)))))
(define (is-num? t)
  (string=? (car (regexp-match #rx"[0-9]*.?[0-9]*" t))
            t))

; Definition of the list of tokens
(define tokens (tokenize empty empty))

; Write out tokens one by one to output file
(define (write-tokens lst)
  (unless (empty? lst)
    (if (or (is-id? (car lst)) (is-num? (car lst)))
            (cond
              [(is-add-op? (car lst)) (display "+" out)]
              [(is-sub-op? (car lst)) (display "-" out)]
              [(is-mult-op? (car lst)) (display "*" out)]
              [(is-div-op? (car lst)) (display "/" out)]
              [(is-assign-op? (car lst)) (display ":=" out)]
              [(is-lparen? (car lst)) (display "(" out)]
              [(is-rparen? (car lst)) (display ")" out)]
              [(is-id? (car lst)) (display "id" out)]
              [(is-num? (car lst)) (display "num" out)])
            (display (car lst) out))
    (display " " out)
    (write-tokens (cdr lst))
    (close-output-port out)))

; One function to process everything
(define go (write-tokens (remove-last tokens)))
