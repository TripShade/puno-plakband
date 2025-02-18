import { Controller, Post, Body } from '@nestjs/common';
import { AppService } from './app.service';
import { MessageDto } from './dto/notification.dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Post('send-multiple-notifications')
  async sendMultipleNotifications(@Body() body: MessageDto) {
    return this.appService.sendNotificationToMultipleTokens({
      tokens: body.tokens,
      title: body.title,
      body: body.body,
    });
  }
}
