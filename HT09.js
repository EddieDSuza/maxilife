const fz = require('zigbee-herdsman-converters/converters/fromZigbee');
const tz = require('zigbee-herdsman-converters/converters/toZigbee');
const exposes = require('zigbee-herdsman-converters/lib/exposes');
const reporting = require('zigbee-herdsman-converters/lib/reporting');
const extend = require('zigbee-herdsman-converters/lib/extend');
const e = exposes.presets;
const ea = exposes.access;

const devices = [
    {
    fingerprint: [
            {type: 'EndDevice', manufacturerID: 4098},
            {manufacturerName: '_TZ3000_6uzkisv2'},
        ],
        //zigbeeModel: ['TS0201'],
        model: 'TS0201',
        vendor: 'PCBLab',
        description: 'Temperature & humidity sensor without display',
        fromZigbee: [fz.battery, fz.temperature, fz.humidity],
        toZigbee: [],
        exposes: [e.battery(), e.temperature(), e.humidity()],
        configure: async (device, coordinatorEndpoint, logger) => {
            const endpoint = device.getEndpoint(1);
            await reporting.bind(endpoint, coordinatorEndpoint, ['msTemperatureMeasurement']);
            await reporting.temperature(endpoint);
        },
    },
];
module.exports = devices;



const definition = {
    zigbeeModel: [modelID: 'TS0601', manufacturerName: '_TZE200_ispx2ewo'],
    model: 'HT-09',
    vendor: 'ETOP',
    description: 'Wall-mount thermostat',
    fromZigbee: [fz.legacy.tuya_thermostat_weekly_schedule, fz.etop_thermostat, fz.ignore_basic_report, fz.ignore_tuya_set_time],
    toZigbee: [tz.etop_thermostat_system_mode, tz.etop_thermostat_away_mode, tz.tuya_thermostat_child_lock, tz.tuya_thermostat_current_heating_setpoint, tz.tuya_thermostat_weekly_schedule], onEvent: tuya.onEventSetTime,
    meta: {
        thermostat: {
                weeklyScheduleMaxTransitions: 4,
                weeklyScheduleSupportedModes: [1], // bits: 0-heat present, 1-cool present (dec: 1-heat,2-cool,3-heat+cool)
                weeklyScheduleFirstDayDpId: tuya.dataPoints.schedule,
            },
        },
    exposes: [e.child_lock(), exposes.climate().withSetpoint('current_heating_setpoint', 5, 35, 0.5, ea.STATE_SET)
            .withLocalTemperature(ea.STATE)
            .withSystemMode(['off', 'heat', 'auto'], ea.STATE_SET).withRunningState(['idle', 'heat'], ea.STATE)
            .withAwayMode()],
    };
    
module.exports = definition;
