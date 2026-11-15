target wasm32 1
declare function @first() -> i32
declare function @second() -> i32
alias object first = @second
alias object second = @first
