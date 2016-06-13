#lang scribble/manual
@; binary-tree.scrbl
@(require (for-label racket "../main.rkt"))
@title{Binary Tree}

@author["Lehi Toskin"]

@defmodule[binary-tree]{
  This library provides functionality for creating and modifying binary trees.
  
  There is also a function provided for graphic creation via @racket[tree->pict].
  
  The following are provided by @racket[binary-tree] and @racket[binary-tree/base].
}

@section[#:tag "structs"]{Basic Structures}

This library has two structs that it uses for everything

@defstruct*[btree ([root node?]
                   [<? (-> any/c any/c boolean?)]
                   [=? (-> any/c any/c boolean?)])
            #:mutable]
@defstruct*[node ([data any/c]
                  [left (or/c node? null?)]
                  [right (or/c node? null?)])
            #:mutable]

@section[#:tag "procedures"]{Procedure List}

@subsection{Constructors}

@deftogether[(@defproc[(make-tree [data any/c] [<? (-> any/c any/c boolean?)]) btree?]
              @defproc[(make-tree-eq [data any/c] [<? (-> any/c any/c boolean?)]) btree?]
              @defproc[(make-tree-eqv [data any/c] [<? (-> any/c any/c boolean?)]) btree?]
              @defproc[(make-custom-tree
                        [data any/c]
                        [<? (-> any/c any/c boolean?)]
                        [=? (-> any/c any/c boolean?)]) btree?])]{
  Procedures to make a new binary tree. @racket[make-tree], @racket[make-tree-eq], and
  @racket[make-tree-eqv] compare elements with @racket[equal?], @racket[eq?] and @racket[eqv?]
  respectively.
  
  @racket[<?] and @racket[=?] should reflect the
  type of data being fed into the tree (i.e. @racket[string<?] or @racket[string=?]).
}

@subsection{Modifiers}

@deftogether[(@defproc[(tree-add [tree btree?] [val any/c] ...) btree?]
              @defproc[(tree-add! [tree btree?] [val any/c] ...) btree?])]{
  Takes at least one variable and adds it to @racket[tree].
}

@defproc[(tree-cons [t1 btree?] [t2 btree?]) btree?]{
  Adds @racket[t2] to the rightmost position of @racket[t1].
}

@deftogether[(@defproc[(tree-append [t1 btree?] [t2 btree?]) btree?]
              @defproc[(tree-append! [t1 btree?] [t2 btree?]) btree?])]{
  Adds the contents of @racket[t2] to @racket[t1].
}

@defproc[(tree-mirror [tree btree?]) btree?]{
  Swaps (inverts) each left and right child in the tree.
}

@deftogether[(@defproc[(tree-remove [tree btree?] [val any/c]) btree?]
              @defproc[(tree-remove! [tree btree?] [val any/c]) btree?])]{
  Removes @racket[val] from @racket[tree].
  Does nothing if @racket[tree] does not contain @racket[val].
}

@subsection{Accessors}

@deftogether[(@defproc[(tree-equal? [tree btree?]) boolean?]
              @defproc[(tree-eq? [tree btree?]) boolean?]
              @defproc[(tree-eqv? [tree btree?]) boolean?])]{
  Checks if the tree has been created using that constructor.
}

@defproc[(tree=? [t1 btree?] [t2 btree?]) boolean?]{
  Checks both the contents and the structure of the trees for equality.
}

@defproc[(tree-contains? [tree btree?] [val any/c]) boolean?]{
  Checks if the tree contains @racket[val].
}

@defproc[(tree-copy [tree btree?]) btree?]{
  Returns a copy of @racket[tree].
}

@defproc[(in-tree [tree btree?]) sequence?]{
  Returns a sequence to iterate over @racket[tree].
}

@defproc[(tree->list [tree btree?]) list?]{
  Returns a list containing the elements of @racket[tree] sorted by @racket[<?].
}

@defproc[(tree-length [tree btree?]) nonnegative-integer?]{
  Returns the number of elements inside @racket[tree].
}

@defproc[(tree-branch [tree btree?] [val any/c]) btree?]{
  Returns the branch of the tree with the root @racket[val].
  If @racket[btree] does not contain @racket[val], a new tree is returned.
}

@defproc[(tree->pict [tree btree?]
                     [#:color color string? "black"]
                     [#:style style procedure? naive-layered]) pict?]{
  Returns a pict with the data of each node (printed with @racket[~v]),
  modified by a color string, and ordered by the style procedure.
  The style procedure must be one of @racket[naive-layered], @racket[binary-tidier],
  or @racket[hv-alternating].

  Provided by @racket[binary-tree] and @racket[binary-tree/graphics].
}

@section[#:tag "license"]{License}

The code in this package and this documentation is licensed under the BSD 3-clause.

@verbatim{
Copyright (c) 2015 - 2016, Lehi Toskin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of typed-stack nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}
