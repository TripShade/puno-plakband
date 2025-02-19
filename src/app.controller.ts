import { Controller, Post, Get, Body } from '@nestjs/common';
import { AppService } from './app.service';
import { MessageDto } from './dto/notification.dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health')
  health() {
    return 'Server is running';
  }

  @Post('send-multiple-notifications')
  async sendMultipleNotifications(@Body() body: MessageDto) {
    return this.appService.sendNotificationToMultipleTokens({
      tokens: body.tokens,
      title: body.title,
      body: body.body,
    });
  }
}
