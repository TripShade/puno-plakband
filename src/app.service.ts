import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { type MulticastMessage } from 'firebase-admin/lib/messaging/messaging-api';
import { MessageDto } from './dto/notification.dto';

@Injectable()
export class AppService {
  async sendNotificationToMultipleTokens({ tokens, title, body }: MessageDto) {
    const message: MulticastMessage = {
      notification: {
        title: title,
        body: body,
      },
      tokens: tokens,
    };

    try {
      const response = await admin
        .messaging()
        .sendEachForMulticast(message, process.env.DRY_RUN === 'true');
      console.log('Successfully sent messages:', response);
      return {
        success: true,
        message: `Successfully sent ${response.successCount} messages; ${response.failureCount} failed.`,
      };
    } catch (error) {
      console.log('Error sending messages:', error);
      return { success: false, message: 'Failed to send notifications' };
    }
  }
}
