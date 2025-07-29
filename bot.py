import telebot

# توکن ربات و آی‌دی ادمین
BOT_TOKEN = '7630876912:AAEIYLt7Fn_Hcmmgs28as7DEIXaWLZ64HHo'
ADMIN_ID = 7623976106  # عدد آی‌دی شما

bot = telebot.TeleBot(BOT_TOKEN)

# 🎉 پیغام خوش‌آمدگویی
@bot.message_handler(commands=['start'])
def send_welcome(message):
    bot.reply_to(message, "👋 سلام! برای شروع دستور زیر رو بفرست:\n\n/attack example.com 443 120 TLS")

# 🎯 هندل دستور اتک
@bot.message_handler(commands=['attack'])
def handle_attack(message):
    try:
        parts = message.text.split()
        if len(parts) != 5:
            bot.reply_to(message, "❌ فرمت اشتباهه!\nاستفاده درست: /attack [host] [port] [time] [method]")
            return

        _, host, port, time, method = parts
        user = message.from_user
        banner = f"""
🚀 <b>حمله آغاز شد!</b>
👤 توسط: @{user.username or user.first_name}
🌐 هدف: <code>{host}</code>
📦 پورت: <code>{port}</code>
⏱ زمان: <code>{time} ثانیه</code>
⚔️ روش: <code>{method}</code>
🟢 وضعیت: <b>ارسال شد</b>
        """

        # ارسال به کاربر
        bot.reply_to(message, banner, parse_mode="HTML")

        # ارسال به ادمین
        bot.send_message(ADMIN_ID, f"📡 گزارش حمله:\n{banner}", parse_mode="HTML")

    except Exception as e:
        bot.reply_to(message, f"⚠️ خطا رخ داد:\n{str(e)}")

# اجرای ربات
print("🤖 Bot is running...")
bot.infinity_polling()