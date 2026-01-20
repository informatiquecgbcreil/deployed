from decimal import Decimal, InvalidOperation, ROUND_HALF_UP

MONEY_QUANT = Decimal("0.01")
MONEY_ZERO = Decimal("0.00")


def money_value(value) -> Decimal:
    if value is None:
        return MONEY_ZERO
    if isinstance(value, Decimal):
        return value
    try:
        return Decimal(str(value))
    except (InvalidOperation, ValueError, TypeError):
        return MONEY_ZERO


def money_quantize(value) -> Decimal:
    return money_value(value).quantize(MONEY_QUANT, rounding=ROUND_HALF_UP)


def parse_money(raw) -> Decimal:
    if raw is None:
        return MONEY_ZERO
    if isinstance(raw, Decimal):
        return money_quantize(raw)
    text = str(raw).strip()
    if not text:
        return MONEY_ZERO
    text = text.replace(" ", "").replace(",", ".")
    try:
        return money_quantize(Decimal(text))
    except (InvalidOperation, ValueError, TypeError):
        return MONEY_ZERO


def money_sum(values) -> Decimal:
    total = MONEY_ZERO
    for value in values:
        total += money_value(value)
    return money_quantize(total)


def money_diff(left, right) -> Decimal:
    return money_quantize(money_value(left) - money_value(right))


def money_to_float(value) -> float:
    return float(money_quantize(value))
