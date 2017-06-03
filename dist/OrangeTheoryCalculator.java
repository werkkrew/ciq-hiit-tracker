package com.netpulse.mobile.orangetheory.model;

import com.annimon.stream.Stream;
import com.annimon.stream.function.BiFunction;
import com.netpulse.mobile.otf_workouts.integration.otbeat.model.HRZone;
import java.util.LinkedList;
import java.util.List;
import se.emilsjolander.stickylistheaders.C1409R;
import timber.log.Timber;

public class OrangeTheoryCalculator {
    private static double PRECISION;
    private final int age;
    private final double ageCoef;
    private int blueZoneTime;
    private List<Double> calculatedHrMeasurements;
    private final double caloriesSumCoef;
    private int considerableCount;
    private double considerableSum;
    private int greenZoneTime;
    private int greyZoneTime;
    private final double hrCoef;
    private List<Integer> hrMeasurements;
    private final boolean isFemale;
    private int orangeZoneTime;
    private int redZoneTime;
    private final double timeCoef;
    private final double weight;
    private final double weightCoef;
    private final ZonesCalculator zonesCalculator;

    /* renamed from: com.netpulse.mobile.orangetheory.model.OrangeTheoryCalculator.1 */
    class C09911 implements BiFunction<Integer, Integer, Integer> {
        C09911() {
        }

        public Integer apply(Integer value1, Integer value2) {
            return Integer.valueOf(value1.intValue() + value2.intValue());
        }
    }

    /* renamed from: com.netpulse.mobile.orangetheory.model.OrangeTheoryCalculator.2 */
    static /* synthetic */ class C09922 {
        static final /* synthetic */ int[] f100xcd1f1557;

        static {
            f100xcd1f1557 = new int[HRZone.values().length];
            try {
                f100xcd1f1557[HRZone.RED.ordinal()] = 1;
            } catch (NoSuchFieldError e) {
            }
            try {
                f100xcd1f1557[HRZone.ORANGE.ordinal()] = 2;
            } catch (NoSuchFieldError e2) {
            }
            try {
                f100xcd1f1557[HRZone.GREEN.ordinal()] = 3;
            } catch (NoSuchFieldError e3) {
            }
            try {
                f100xcd1f1557[HRZone.BLUE.ordinal()] = 4;
            } catch (NoSuchFieldError e4) {
            }
        }
    }

    public static class ZonesCalculator {
        private static final double BLUE_ZONE_VALUE = 0.61d;
        private static final int DEFAULT_MAX_HR = 230;
        private static final double GREEN_ZONE_VALUE = 0.71d;
        private static final double ORANGE_ZONE_VALUE = 0.84d;
        private static final double RED_ZONE_VALUE = 0.92d;
        private final int blueZone;
        private final int greenZone;
        private final int maxHR;
        private final int orangeZone;
        private final int redZone;

        public ZonesCalculator(int maxHR) {
            if (maxHR != 0) {
                this.maxHR = maxHR;
            } else {
                this.maxHR = DEFAULT_MAX_HR;
            }
            this.redZone = (int) (((double) this.maxHR) * RED_ZONE_VALUE);
            this.orangeZone = (int) (((double) this.maxHR) * ORANGE_ZONE_VALUE);
            this.greenZone = (int) (((double) this.maxHR) * GREEN_ZONE_VALUE);
            this.blueZone = (int) (((double) this.maxHR) * BLUE_ZONE_VALUE);
        }

        public HRZone getCurrentHRZone(double value) {
            if (value < ((double) this.blueZone)) {
                return HRZone.GREY;
            }
            if (value < ((double) this.greenZone)) {
                return HRZone.BLUE;
            }
            if (value < ((double) this.orangeZone)) {
                return HRZone.GREEN;
            }
            if (value < ((double) this.redZone)) {
                return HRZone.ORANGE;
            }
            return HRZone.RED;
        }

        public int getMaxHR() {
            return this.maxHR;
        }

        public int getRedZone() {
            return this.redZone;
        }

        public int getOrangeZone() {
            return this.orangeZone;
        }

        public int getGreenZone() {
            return this.greenZone;
        }

        public int getBlueZone() {
            return this.blueZone;
        }
    }

    static {
        PRECISION = 100000.0d;
    }

    public OrangeTheoryCalculator(boolean isFemale, int age, double weight) {
        this.timeCoef = 4.184d;
        this.hrMeasurements = new LinkedList();
        this.calculatedHrMeasurements = new LinkedList();
        this.considerableSum = 0.0d;
        this.considerableCount = 0;
        this.isFemale = isFemale;
        this.age = age;
        this.weight = weight;
        this.zonesCalculator = new ZonesCalculator(isFemale ? 230 - age : 225 - age);
        this.ageCoef = isFemale ? 0.074d : 0.2017d;
        this.weightCoef = isFemale ? -0.05741d : 0.09036d;
        this.hrCoef = isFemale ? 0.4472d : 0.6309d;
        this.caloriesSumCoef = isFemale ? -20.4022d : -55.0969d;
    }

    public double addHRMeasurement(int hr, boolean consider) {
        double finalHR;
        if (consider) {
            this.hrMeasurements.add(Integer.valueOf(hr));
            finalHR = (double) hr;
            this.considerableSum += finalHR;
            this.considerableCount++;
        } else {
            finalHR = 0.0d;
        }
        calculateHRZoneTime(finalHR);
        this.calculatedHrMeasurements.add(Double.valueOf(finalHR));
        return finalHR;
    }

    private void calculateHRZoneTime(double finalHR) {
        switch (C09922.f100xcd1f1557[this.zonesCalculator.getCurrentHRZone(finalHR).ordinal()]) {
            case C1409R.styleable.StickyListHeadersListView_android_padding /*1*/:
                this.redZoneTime++;
            case C1409R.styleable.StickyListHeadersListView_android_paddingLeft /*2*/:
                this.orangeZoneTime++;
            case C1409R.styleable.StickyListHeadersListView_android_paddingTop /*3*/:
                this.greenZoneTime++;
            case C1409R.styleable.StickyListHeadersListView_android_paddingRight /*4*/:
                this.blueZoneTime++;
            default:
                this.greyZoneTime++;
        }
    }

    private double calculateSMA(int size) {
        int count = Math.min(this.hrMeasurements.size(), size);
        return ((double) ((Integer) Stream.of(this.hrMeasurements.subList(this.hrMeasurements.size() - count, this.hrMeasurements.size())).reduce(Integer.valueOf(0), new C09911())).intValue()) / ((double) count);
    }

    public int getSplatPoints() {
        return (this.redZoneTime + this.orangeZoneTime) / 60;
    }

    public double getCaloriesBurned() {
        Timber.m11d(String.format("age: %d, weignt: %.3f, hr: %.03f, time: %.3f, calories: %.3f", new Object[]{Integer.valueOf(this.age), Double.valueOf(this.weight), Double.valueOf(averageHR), Double.valueOf(((double) ((long) this.considerableCount)) / 60.0d), Double.valueOf((((((((double) this.age) * this.ageCoef) + (this.weight * this.weightCoef)) + (this.hrCoef * getAverageHR())) + this.caloriesSumCoef) * (((double) ((long) this.considerableCount)) / 60.0d)) / 4.184d)}), new Object[0]);
        return (((((((double) this.age) * this.ageCoef) + (this.weight * this.weightCoef)) + (this.hrCoef * getAverageHR())) + this.caloriesSumCoef) * (((double) ((long) this.considerableCount)) / 60.0d)) / 4.184d;
    }

    public double getAverageHR() {
        if (this.considerableCount == 0) {
            return 0.0d;
        }
        return this.considerableSum / ((double) this.considerableCount);
    }

    public ZonesCalculator getZonesCalculator() {
        return this.zonesCalculator;
    }

    public int getRedZoneTime() {
        return this.redZoneTime;
    }

    public int getOrangeZoneTime() {
        return this.orangeZoneTime;
    }

    public int getGreenZoneTime() {
        return this.greenZoneTime;
    }

    public int getBlueZoneTime() {
        return this.blueZoneTime;
    }

    public int getGreyZoneTime() {
        return this.greyZoneTime;
    }

    public List<Double> getCalculatedHrMeasurements() {
        return this.calculatedHrMeasurements;
    }

    public List<Integer> getHrMeasurements() {
        return this.hrMeasurements;
    }
}
