import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import FriendlyCaptchaSDK from '@salesforce/resourceUrl/FriendlyCaptchaSDK';

export default class FriendlyCaptchaWidget extends LightningElement {
  @api sitekey;
  @api apiEndpoint;
  @api startMode;
  @api language;
  @api theme;

  widget = null;

  async renderedCallback() {
    if (!window.frcaptcha) {
      await loadScript(this, FriendlyCaptchaSDK);
    }

    if (this.widget === null) {
      this.widget = frcaptcha.createWidget({
        element: this.refs.frcaptcha,
        sitekey: 'FCMKRFNE61OM0D4Q',
      });
    } else {
      this.widget.reset();
    }
  }
}
