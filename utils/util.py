import urllib.parse

def encode_email_value(email):
    """URL encodes an email address string for use as an HTTP path parameter.

    This function strictly encodes all special characters (such as '@' and '+')
    by setting safe="" to ensure the resulting string can be safely appended
    to a URL path without being misinterpreted by web servers.

    Args:
        email (str): The raw email address to be encoded.

    Returns:
        str: The fully URL-encoded email address string.

    Example:
        >>> encode_email_value("user.name+tag@example.com")
        'user.name%2Btag%40example.com'
    """
    encoded_email = urllib.parse.quote(email, safe="")
    return encoded_email