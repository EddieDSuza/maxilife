const exposes = require('../lib/exposes');
const fz = {...require('../converters/fromZigbee'), legacy: require('../lib/legacy').fromZigbee};
const tz = require('../converters/toZigbee');
const ota = require('../lib/ota');
const tuya = require('../lib/tuya');
const reporting = require('../lib/reporting');
const extend = require('../lib/extend');
const e = exposes.presets;
const ea = exposes.access;

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
