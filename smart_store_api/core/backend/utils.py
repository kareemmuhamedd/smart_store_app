from datetime import timedelta, timezone
import datetime
from random import randint
import uuid
from rest_framework.response import Response

from backend.models import Otp, PasswordResetToken, Token
from core.settings import TEMPLATES_BASE_URL
from django.core.mail import EmailMessage
from django.template.loader import get_template
from rest_framework.permissions import BasePermission


def send_otp(phone):
    # todo sms api
    otp = randint(100000, 999999)
    validity = datetime.datetime.now() + datetime.timedelta(minutes=10)
    Otp.objects.update_or_create(
        phone=phone,
        defaults={
            "otp": otp,
            "validity": validity,
            "verified": False,
        },
    )
    print(otp)
    return Response("otp sent successfully")


def new_token():
    token = uuid.uuid4().hex
    return token


def token_response(user):
    token = new_token()
    Token.objects.create(user=user, token=token)
    return Response({"token": token})


def send_password_reset_email(user):
    token = new_token()
    exp_time = datetime.datetime.now() + datetime.timedelta(minutes=10)
    PasswordResetToken.objects.update_or_create(
        user=user,
        defaults={
            "user": user,
            "token": token,
            "created_at": exp_time,
        },
    )
    email_data = {
        "token": token,
        "email": user.email,
        "base_url": TEMPLATES_BASE_URL,
    }

    message = get_template("emails/reset-password.html").render(email_data)

    msg = EmailMessage(
        "Reset Password",
        body=message,
        to=[user.email],
    )

    msg.content_subtype = "html"

    try:
        msg.send()
    except Exception as e:
        print(e)
        return Response("unable to send password reset email", status=400)
    return Response("reset_password_email_sent")


class IsAuthenticatedUser(BasePermission):
    message = "unauthenticated_user"

    def has_permission(self, request, view):
        return bool(request.user)
