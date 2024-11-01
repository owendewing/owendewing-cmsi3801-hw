exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

let first_then_apply array predicate consumer =
  match List.find_opt predicate array with
  | None -> None
  | Some x -> consumer x;;

let powers_generator base =
  let rec generate_power power () =
    Seq.Cons (power, generate_power (power * base))
  in
  generate_power 1;;

let meaningful_line_count filename =
  let meaningful_line line =
    let trimmed_line = String.trim line in
    String.length trimmed_line > 0 && not (String.get trimmed_line 0 = '#')
  in
  let file_input = open_in filename in
  Fun.protect
    ~finally:(fun () -> close_in file_input)
    (fun () ->
      let rec count_lines accumulator =
        try
          let current_line = input_line file_input in
          count_lines (accumulator + if meaningful_line current_line then 1 else 0)
        with End_of_file -> accumulator
      in
      count_lines 0);;

type shape =
  | Sphere of float
  | Box of float * float * float

let volume = function
  | Sphere radius ->
    (4.0 /. 3.0) *. Float.pi *. (radius ** 3.0)
  | Box (l, w, h) ->
    l *. w *. h;;

let surface_area = function
  | Sphere radius ->
    4.0 *. Float.pi *. (radius ** 2.0)
  | Box (l, w, h) ->
    2.0 *. (l *. w +. l *. h +. w *. h);;

type 'a binary_search_tree =
  | Empty
  | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

let rec size tree =
  match tree with
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right;;

let rec contains value tree =
  match tree with
  | Empty -> false
  | Node (left, v, right) ->
    if value = v then
      true
    else if value < v then
      contains value left
    else
      contains value right;;

let rec inorder tree =
  match tree with
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right;;

let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
    if value < v then
      Node (insert value left, v, right)
    else if value > v then
      Node (left, v, insert value right)
    else
      tree;;
