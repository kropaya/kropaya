(print "test 'wrapped' around star(none-of-lit)")
(print (funcall (wrapped (star (none-of-lit 1 "\"" "\\"))
                (lambda (data start end text)
                            (cons (list 'text (substring text start end)) data)))  "efwlkn e kj\\fe klen flne " 0 '()))
(print "test funcall (star (alt (...)))")
(print (funcall (star (alt (none-of-lit 1 "\"" "\\") (lit "\\\"") (lit "\\\\"))) "efwlkn e kjfe klen flne " 0 '()))
(print "test parse-string")
(print (parse-string "\"dlifhwelihf oih w okefn wle\\\\ef 2 2\\\"ef \"" 0 '()))
(print (parse-string "\"dlifhwelihf oih w okefn wle\\\\ef 2 2\\\"ef " 0 '()))
(print (parse-string "\"dlifhwelihf oih w okefn wle\\ef 2 2\\\"ef \"" 0 '()))