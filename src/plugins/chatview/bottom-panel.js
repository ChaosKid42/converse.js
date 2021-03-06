import './message-form.js';
import debounce from 'lodash-es/debounce';
import tpl_bottom_panel from './templates/bottom-panel.js';
import { ElementView } from '@converse/skeletor/src/element.js';
import { _converse, api } from '@converse/headless/core';
import { clearMessages } from './utils.js';
import { render } from 'lit';

import './styles/chat-bottom-panel.scss';


export default class ChatBottomPanel extends ElementView {
    events = {
        'click .send-button': 'sendButtonClicked',
        'click .toggle-clear': 'clearMessages'
    };

    async connectedCallback () {
        super.connectedCallback();
        this.debouncedRender = debounce(this.render, 100);
        this.model = _converse.chatboxes.get(this.getAttribute('jid'));
        await this.model.initialized;
        this.listenTo(this.model, 'change:num_unread', this.debouncedRender)
        this.listenTo(this.model, 'emoji-picker-autocomplete', this.autocompleteInPicker);

        this.addEventListener('focusin', ev => this.emitFocused(ev));
        this.addEventListener('focusout', ev => this.emitBlurred(ev));
        this.render();
    }

    render () {
        render(tpl_bottom_panel({
            'model': this.model,
            'viewUnreadMessages': ev => this.viewUnreadMessages(ev)
        }), this);
    }

    sendButtonClicked (ev) {
        this.querySelector('converse-message-form')?.onFormSubmitted(ev);
    }

    viewUnreadMessages (ev) {
        ev?.preventDefault?.();
        this.model.save({ 'scrolled': false });
    }

    emitFocused (ev) {
        _converse.chatboxviews.get(this.getAttribute('jid'))?.emitFocused(ev);
    }

    emitBlurred (ev) {
        _converse.chatboxviews.get(this.getAttribute('jid'))?.emitBlurred(ev);
    }

    getToolbarOptions () { // eslint-disable-line class-methods-use-this
        return {};
    }

    onDrop (evt) {
        if (evt.dataTransfer.files.length == 0) {
            // There are no files to be dropped, so this isn’t a file
            // transfer operation.
            return;
        }
        evt.preventDefault();
        this.model.sendFiles(evt.dataTransfer.files);
    }

    onDragOver (ev) { // eslint-disable-line class-methods-use-this
        ev.preventDefault();
    }

    clearMessages (ev) {
        ev?.preventDefault?.();
        clearMessages(this.model);
    }

    async autocompleteInPicker (input, value) {
        await api.emojis.initialize();
        const emoji_picker = this.querySelector('converse-emoji-picker');
        if (emoji_picker) {
            emoji_picker.model.set({
                'ac_position': input.selectionStart,
                'autocompleting': value,
                'query': value
            });
            const emoji_dropdown = this.querySelector('converse-emoji-dropdown');
            emoji_dropdown?.showMenu();
        }
    }
}

api.elements.define('converse-chat-bottom-panel', ChatBottomPanel);
