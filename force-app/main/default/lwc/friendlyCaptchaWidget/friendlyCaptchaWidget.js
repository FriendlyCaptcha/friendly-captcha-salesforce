import { LightningElement, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import FriendlyCaptchaSDK from '@salesforce/resourceUrl/FriendlyCaptchaSDK';
import loadConfig from '@salesforce/apex/SettingsController.get'

export default class FriendlyCaptchaWidget extends LightningElement {
  @api sitekey;
  @api apiEndpoint;
  @api startMode;
  @api language;
  @api theme;

  @wire(loadConfig)
  config;

  widget = null;

  async renderedCallback() {
    if (!window.frcaptcha) {
      await loadScript(this, FriendlyCaptchaSDK);
    }

    if (this.widget === null) {
      const opts = {
        element: this.refs.frcaptcha,
        sitekey: this.sitekey || this.config?.data.sitekey,
        apiEndpoint: this.apiEndpoint || this.config?.data.apiEndpoint || 'global',
        startMode: this.startMode || this.config?.data.startMode || 'focus',
        theme: this.theme || this.config?.data.theme || 'light',
      }

      const lang = this.language || this.config?.data.language;
      if (lang) {
        opts.language = lang;
      }

      this.widget = frcaptcha.createWidget(opts);
    } else {
      this.widget.reset();
    }
  }
}
