global @compte_é : i32 = 42

function @读() -> i32 {
  block ^entrée:
    %résultat = load i32 @compte_é
    return i32 %résultat
}
