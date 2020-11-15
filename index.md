Copyright (C) Nimrod Gilboa-Markevich and Avishai Wool 2019-2020. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">
<center><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a></center>

This data corpus is licensed under a 
<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

If you find this data useful, we ask that you cite our paper:

N. Gilboa-Markevich and A. Wool. <a href=https://doi.org/10.1007/978-3-030-59013-0_3>Hardware fingerprinting for the ARINC 429 avionic bus</a>.<br>
In *Proc. 25th European Symposium on Research in Computer Security (ESORICS), LNCS 12309 Part II, pages 42–62, University of Surrey, UK, September 2020*.

---

This data corpus contains 137,760 recorded ARINC 429 words from 10 different transmitters communicating with 6 different receivers. The data corpus is described in detail in section 3 of the above paper.
Each file contains a recording of a 246 words that were obtained from a combination of a transmitter, a receiver and optionally a second receiver which corresponds to one row in Table 1.
Each row has more than 1 corresponding file. There are twice as many words in the corpus for rows #1 and #14 than were used in the original paper.

The file format is HDF5, a hierarchical file format in which data is stored in a file-system-like manner.
Inside each file data is stored in groups:

- **Channel_1:** voltage levels of ARINC429 Line A, y-axis
- **Channel_2:** voltage levels of ARINC429 Line B, y-axis
- **General:** time duration, x-axis
- **metadata:** setup description. Most importantly transmitter ID, receiver ID, and additional receiver ID if present (**tx_id**, **rx_id** and **load** respectively)

Voltage levels are stored as 3 datasets (arrays) under the **Channel_1** and **Channel_2** groups:

- **Data:** A/D counts, a vector of pure numbers
- **YInc:** Y increment, voltage corresponding to 1 count, a scalar, measured in volts
- **YOrg:** Y origin, number of counts at voltage level 0, a scalar, measured in volts

Voltage levels are obtained from the following formula:

```
V (volts) = YOrg + Data * YInc
```

Time duration is stores as 3 datasets under the **General** group:

- **NumPoints:** Number of sampled points, a scalar, a pure number
- **XInc:** X increment, time between data points, a scalar, measured in seconds
- **XOrg:** X origin, time of the first point, a scalar, measured in seconds

---

A python example for extracting the metadata and the voltage levels:

```python
import h5py
import numpy as np

def read_metadata(filename):
    with h5py.File(filename, 'r') as f:
        metadata = {k: v[()] for (k, v) in f['metadata'].items()}

    return metadata

def read_sig(filename):
    with h5py.File(filename, 'r') as f:
        length = f['Channel_1/Data'].shape[0]

    sig_x, sig_y = read_sig_sliced(filename, 0, length)

    return sig_x, sig_y

def read_sig_sliced(filename, start, stop):
    with h5py.File(filename, 'r') as f:
        Data_a = f['Channel_1/Data'][start:stop]
        YInc_a = f['Channel_1/YInc'][()]
        YOrg_a = f['Channel_1/YOrg'][()]
        Data_b = f['Channel_2/Data'][start:stop]
        YInc_b = f['Channel_2/YInc'][()]
        YOrg_b = f['Channel_2/YOrg'][()]
        XInc = f['General/XInc'][()]

    line_a = YOrg_a + Data_a * YInc_a
    line_b = YOrg_b + Data_b * YInc_b
    sig_y = line_a - line_b
    sig_x = np.arange(sig_y.shape[0]) * XInc

    return sig_x, sig_y
```

---

Send comments to<br>
&nbsp;&nbsp;Nimrod Gilboa-Markevich  <gmnimrod@gmail.com><br>
&nbsp;&nbsp;Avishai Wool <yash@eng.tau.ac.il><br>
&nbsp;&nbsp;http://www.eng.tau.ac.il/~yash
