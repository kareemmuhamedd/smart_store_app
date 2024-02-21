from random import choice
import re
import uuid
from django.db import models


# Create your models here.
class User(models.Model):
    email = models.EmailField()
    phone = models.CharField(max_length=15)
    fullname = models.CharField(max_length=100)
    password = models.CharField(max_length=5000)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email


class Otp(models.Model):
    phone = models.CharField(max_length=10)
    otp = models.IntegerField()
    validity = models.DateTimeField()
    verified = models.BooleanField(default=False)

    def __str__(self):
        return self.phone


class Token(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="tokens_set")
    token = models.CharField(max_length=5000)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.user.email


class PasswordResetToken(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="password_reset_tokens_set"
    )
    token = models.CharField(max_length=5000)
    created_at = models.DateTimeField()

    def __str__(self):
        return self.user.email


class Category(models.Model):
    name = models.CharField(max_length=100)
    position = models.IntegerField(default=0)
    image = models.ImageField(upload_to="categories/")

    def __str__(self):
        return self.name


class Slide(models.Model):
    position = models.IntegerField(default=0)
    image = models.ImageField(upload_to="slides/")


class Product(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=100)
    category = models.ForeignKey(
        Category, on_delete=models.CASCADE, related_name="products_set"
    )
    description = models.TextField()
    price = models.FloatField()
    offer_price = models.FloatField(default=0)
    delivery_charge = models.FloatField(default=0)
    star_5 = models.IntegerField(default=0)
    star_4 = models.IntegerField(default=0)
    star_3 = models.IntegerField(default=0)
    star_2 = models.IntegerField(default=0)
    star_1 = models.IntegerField(default=0)
    cod = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title


class ProductOption(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name="options_set",
    )
    option = models.CharField(max_length=50)
    quantity = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.product.title} - {self.option}"


class ProductImage(models.Model):
    position = models.IntegerField(default=0)
    image = models.ImageField(upload_to="products/")
    product_option = models.ForeignKey(
        ProductOption,
        on_delete=models.CASCADE,
        related_name="images_set",
    )


class PageItem(models.Model):
    position = models.IntegerField(default=0)
    image = models.ImageField(upload_to="pages/", blank=True)
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        related_name="pageitems_set",
    )
    choices = [
        (1, "BANNER"),
        (2, "SWIPER"),
        (3, "GRID"),
    ]
    viewtype = models.IntegerField(choices=choices)
    title = models.CharField(max_length=50, blank=True)
    product_options = models.ManyToManyField(ProductOption, blank=True)

    def __str__(self):
        return f"{self.category.name} - {self.title}"
