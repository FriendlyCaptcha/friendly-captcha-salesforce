import { LightningElement, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import FriendlyCaptchaSDK from '@salesforce/resourceUrl/FriendlyCaptchaSDK';
import getConfig from '@salesforce/apex/SettingsController.get'

export default class FriendlyCaptchaWidget extends LightningElement {
  @api sitekey;
  @api apiEndpoint;
  @api startMode;
  @api language;
  @api theme;

  configFetched = false;
  htmlRendered = false;
  remoteConfig = {};
  widget = null;

  @wire(getConfig) fetchConfig({ data, error }) {
    // On construction, these are both empty, exit early.
    if (!data && !error) {
      return;
    }

    this.configFetched = true;

    if (data) {
      this.remoteConfig = data;
    } else if (error) {
      console.warn('[FriendlyCaptchaWidget] Error fetching configuration:', error);
    }

    this.renderWidget();
  }

  async renderedCallback() {
    this.htmlRendered = true;

    if (!window.frcaptcha) {
      await loadScript(this, FriendlyCaptchaSDK);
    }

    this.renderWidget();
  }

  renderWidget() {
    // Only load the widget once the HTML is available
    // and the settings have been retrieved from the back-end.
    if (!(this.htmlRendered && this.configFetched)) {
      return;
    }

    // Guard for the widget already existing.
    if (this.widget !== null) {
      return;
    }

    const sitekey = this.sitekey || this.remoteConfig.sitekey;
    if (!sitekey) {
      console.error('[FriendlyCaptchaWidget] Missing "sitekey" parameter')
      return;
    }

    const opts = {
      element: this.refs.frcaptcha,
      sitekey: sitekey,
      apiEndpoint: this.apiEndpoint || this.remoteConfig.apiEndpoint || 'global',
      startMode: this.startMode || this.remoteConfig.startMode || 'focus',
      theme: this.theme || this.remoteConfig.theme || 'light',
    }

    const language = this.language || this.remoteConfig.language;
    if (language) {
      opts.language = language;
    }

    this.widget = window.frcaptcha.createWidget(opts);

    this.widget.addEventListener('frc:widget.complete', this.handleComplete);
    this.widget.addEventListener('frc:widget.error', this.handleError);
    this.widget.addEventListener('frc:widget.expire', this.handleExpire);
    this.widget.addEventListener('frc:widget.reset', this.handleReset);
    this.widget.addEventListener('frc:widget.statechange', this.handleStateChange);
  }

  disconnectedCallback() {
    if (this.widget !== null) {
      this.widget.removeEventListener('frc:widget.complete', this.handleComplete);
      this.widget.removeEventListener('frc:widget.error', this.handleError);
      this.widget.removeEventListener('frc:widget.expire', this.handleExpire);
      this.widget.removeEventListener('frc:widget.reset', this.handleReset);
      this.widget.removeEventListener('frc:widget.statechange', this.handleStateChange);
      this.widget.destroy();
    }
  }

  handleComplete = ({ detail }) => {
    this.dispatchEvent(new CustomEvent('complete', { detail }));
  }

  handleError = ({ detail }) => {
    this.dispatchEvent(new CustomEvent('error', { detail }));
  }

  handleExpire = ({ detail }) => {
    this.dispatchEvent(new CustomEvent('expire', { detail }));
  }

  handleReset = ({ detail }) => {
    this.dispatchEvent(new CustomEvent('reset', { detail }));
  }

  handleStateChange = ({ detail }) => {
    this.dispatchEvent(new CustomEvent('statechange', { detail }));
  }
}
