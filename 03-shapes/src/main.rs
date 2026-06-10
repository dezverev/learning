enum Shape {
    Rectangle { width: u32, height: u32 },
    Square { size: u32 },
    Circle { radius: u32 },
}

impl Shape {
    fn area(&self) -> u32 {
        match self {
            Shape::Rectangle { width, height } => width * height,
            Shape::Square { size } => size * size,
            Shape::Circle { radius } => 3 * (radius * radius),
        }
    }
}

fn scale(shape: &Shape, factor: u32) -> Option<Shape> {
    if factor == 0 {
        None
    } else {
        Some(match shape {
            Shape::Rectangle { width, height } => Shape::Rectangle {
                width: width * factor,
                height: height * factor,
            },
            Shape::Square { size } => Shape::Square {
                size: size * factor,
            },
            Shape::Circle { radius } => Shape::Circle {
                radius: radius * factor,
            },
        })
    }
}

fn print_shape_area(maybe_shape: &Option<Shape>) {
    match maybe_shape {
        Some(shape) => println!("Shape area: {}", shape.area()),
        None => println!("could not scale"),
    }
}

fn main() {
    let rect = Shape::Rectangle {
        width: 10,
        height: 5,
    };

    println!("rect area: {}", rect.area());

    let sqr = Shape::Square { size: 5 };
    println!("sqr area : {}", sqr.area());

    let circ = Shape::Circle { radius: 5 };
    println!("circ area : {}", circ.area());

    let rect2 = scale(&rect, 2);
    print_shape_area(&rect2);

    println!("rect area : {}", rect.area());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rect_area_returns_correct_result() {
        let rect = Shape::Rectangle {
            width: 10,
            height: 5,
        };

        assert_eq!(rect.area(), 50);
    }

    #[test]
    fn square_area_returns_correct_result() {
        let sqr = Shape::Square { size: 5 };
        assert_eq!(sqr.area(), 25);
    }

    #[test]
    fn circle_area_returns_correct_result() {
        let cir = Shape::Circle { radius: 3 };
        assert_eq!(cir.area(), 27);
    }
}
