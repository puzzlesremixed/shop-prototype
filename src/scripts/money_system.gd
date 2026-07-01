extends Node
class_name MoneySystem

signal balance_updated
var balance: int;

func update_balance(amount: int):
	balance += amount
	balance_updated.emit(balance)
