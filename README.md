# Bing Rewarder

Perform automatic searches on Bing to earn Microsoft Rewards points.

The Bash script `rewarder.sh` performs 30 PC searches and 20 mobile searches.

During every search, a keyword is chosen randomly from `/usr/share/dict/words` (this could be replaced by other line-separated dictionary file).

## Usage

1. first you need a Microsoft account that is registered with Microsoft Rewards

2. login with the account on any browser

3. retrieve and store the cookies as `cookies.txt` in the same folder as `rewarder.sh`

4. run `rewarder.sh`:

```
bash rewarder.sh
```
