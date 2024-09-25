BEGIN{
    min = 100.0
}

/nelements/{
    nel = $6;
}

/Poly order/{
    lx = $4 + 1;
}

/Fluid step time/{
    i += 1;
    if (i > 100)
    {
        t = $5;
        tt += t;
        ttt += t*t;
        n += 1;
        if (max < t) {max = t};
        if (min > t) {min = t};
    }
}

END{
    if (n > 0)
    {
        avg_t=tt/n;
        avg_tt=ttt/n;
        gdofs = ((nel * lx * lx * lx) / avg_t) / 1e9;
    }
    else
    {
        avg_t = 0;
        avg_tt = 0;
        min = 0;
    }
    if (n > 1)
        err_t = sqrt((avg_tt-avg_t*avg_t)/(n-1));
    else
        err_t = 0;
    printf("%5d meas: %7.4f +/- %7.4f s, range: [ %7.4f , %7.4f ], GDoF/s: %7.4f\n", n, avg_t, avg_tt, min, max, gdofs)
}
