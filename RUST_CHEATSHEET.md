# Rust Cheatsheet / Gotchas

Short notes for the things that are easy to forget while learning Rust.

## Strings

`"hello"` is a string literal.

Its type is:

```rust
&str
```

Think: borrowed text. Good for reading.

`String::from("hello")` creates an owned string.

Its type is:

```rust
String
```

Think: owned text. Good when you need to change or grow it.

`String::from("hello")` does not make the variable mutable by itself.

This is owned but not mutable:

```rust
let text = String::from("hello");
```

This is owned and mutable:

```rust
let mut text = String::from("hello");
```

Example:

```rust
let mut text = String::from("hello");
text.push('!');
```

Gotcha:

```rust
let text = "hello";
text.push('!');
```

That does not work because `text` is a `&str`, not a mutable `String`.

## Associated Functions

`String::from("Hi")` means:

```text
call the function named from on the String type
```

This is called an associated function.

Pattern:

```text
Type::function(...)
```

Examples:

```rust
String::from("Hi");
Vec::new();
```

This is different from a method call on a value:

```rust
text.push('!');
```

Pattern:

```text
value.method(...)
```

## Macros

In Rust, `!` means macro.

```rust
println!("hello");
assert_eq!(left, right);
vec![1, 2, 3];
```

Simple rule:

```text
name()   function
name!()  macro
```

Macros can do things normal functions cannot, like print better error messages.

## Tests

Test code usually goes at the bottom of the file.

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example_test() {
        assert_eq!(2 + 2, 4);
    }
}
```

Meaning:

```text
#[cfg(test)]   only compile this when running tests
mod tests      make a tests section
use super::*   use the code from above
#[test]        this function is a test
assert_eq!     fail if the two values are not equal
```

Run tests:

```sh
cargo test
```

In Neovim:

```text
Space c t
```

## Option, Some, None

`Option<T>` means:

```text
maybe there is a T, maybe there is not
```

It is Rust's replacement for nullable values.

```rust
Option<Shape>
```

means:

```text
maybe there is a Shape, maybe there is no Shape
```

`Some(value)` means there is a value.

```rust
Some(Shape::Square { size: 5 })
```

`None` means there is no value.

```rust
None
```

You usually handle `Option` with `match`:

```rust
match maybe_shape {
    Some(shape) => println!("area: {}", shape.area()),
    None => println!("no shape"),
}
```

Gotcha:

```text
Rust makes you handle both Some and None.
That is how Rust avoids silent null bugs.
```

## Cargo

Cargo package names cannot start with a number.

This fails:

```sh
cargo new 03-shapes
```

Use a numbered folder with a valid package name:

```sh
cargo new 03-shapes --name shapes
```

The folder is `03-shapes`, but the package name is `shapes`.

## Ownership

Basic rules:

```text
&      borrow
&mut   borrow mutably
```

Only one mutable borrow at a time.

Many read-only borrows are okay.

## Borrowed Parameters

To accept a borrowed value:

```rust
fn scale(shape: &Shape, factor: u32) -> Option<Shape> {
```

Do not write this:

```rust
fn scale(&shape: &Shape, factor: u32) -> Option<Shape> {
```

That second version does not mean "borrow shape."

It means:

```text
take a &Shape, then pattern-match it and try to move the inner Shape into a new variable
```

That fails when `Shape` is not `Copy`.

Same rule:

```rust
fn print_shape_area(maybe_shape: &Option<Shape>) {
```

not:

```rust
fn print_shape_area(&maybe_shape: &Option<Shape>) {
```
