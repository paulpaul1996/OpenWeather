import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class AccountWeather extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: ['Account.BillingCity','Account.BillingCountry','Account.AccountCurrentWeather__c', 'Account.BillingLatitude','Account.BillingLongitude']})
    account;
    weather;

    get billingAddress() {
        return getFieldValue(this.account.data, 'Account.BillingCity') + ' ' + getFieldValue(this.account.data, 'Account.BillingCountry');
    }

    get currentWeather() {
        this.weather = getFieldValue(this.account.data, 'Account.AccountCurrentWeather__c');
    }

    get billingLatitude(){
        return getFieldValue(this.account.data, 'Account.BillingLatitude');
    }
    
    get billingLongitude() {
        return getFieldValue(this.account.data, 'Account.BillingLongitude');
    }

    
    renderedCallback() {
        refreshApex(this.account);
        if(this.billingLongitude && this.billingLatitude) {
            let endPoint = "https://api.openweathermap.org/data/2.5/onecall?lat=" + this.billingLatitude +"&lon=" + this.billingLongitude + "&appid=09a93c50ae11be4f195dbb9a9d1caff5";
            console.log(endPoint);
            fetch(endPoint)
            .then((response) => {
                response.json().then(result => this.weather = result.current.weather[0].description);
            })
        } else {
            this.weather = 'Invalid latitude and longitude';
        }
    }
}
